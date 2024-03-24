{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }: {
  home.stateVersion = "21.11";
  home.packages = with pkgs; [
    nixfmt

    devbox # declarative environments

    # nvim + config stuff
    neovim
    fennel
    fnlfmt
    fennel-ls

    nixd

    ghq
    gh
    glab

    ripgrep
    coreutils-prefixed
    gnupg
    age
    jq
    fd
    httpie

    glow
    mdcat
    bat

    myougiden

    bitwarden-cli

    # rather not have them global, but it simplifies some stuff for now
    nodejs

    rustup # :/
    # let's try some gui apps now that we're using raycast
    # github-desktop # not packaged for silicon yet
    mpv
  ];

  # too volatile to embed in nix configuration for now
  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Code/github.com/itsbth/dotfiles/nvim/.config/nvim";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Bjørn Tore Håvie";
    userEmail = "itsbth@itsbth.com";
    # delta = {
    #   enable = true;
    # };
    difftastic.enable = true;
    ignores = [ ".vim" ".direnv" ];
    includes = [{
      path = pkgs.writeText "work.inc" ''
        [user]
          email = bth@neowit.io
      '';
      condition = "gitdir:~/Code/gitlab.com/neowit/";
    }];
    extraConfig = {
      ghq.root = "~/Code";
      url."git@github.com:itsbth/".insteadOf = "https://github.com/itsbth/";
      push.autoSetupRemote = true;
    };
  };

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = { sync_address = "https://atuin.itsbth.party"; };
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    syntaxHighlighting = { enable = true; };
    autosuggestion = { enable = true; };
    shellAliases = { };
    initExtra = ''
      bindkey -e
      take() { mkdir -p "$@" && cd "$@" }

      if [[ ! -z "$ITERM_SESSION_ID" ]]; then
        source ${../config/iterm2_shell_integration.zsh}
      fi

      # utilities that are occasionally used outside of project-specific
      # environments, but I don't want globally installed
      local to_wrap=( wget htop kubectl kubectx )
      for cmd ( $to_wrap ); do
        if [[ $+commands[$cmd] -eq 0 ]]; then
          eval "function $cmd() { nix run nixpkgs\#$cmd -- \"\$@\"; }"
        fi
      done
      unset to_wrap
    '';
    plugins = [
      {
        name = "zsh-fzf-ghq";
        src = pkgs.fetchFromGitHub {
          owner = "itsbth";
          repo = "zsh-fzf-ghq";
          rev = "master";
          sha256 = "sha256-4y19nUEKBPPe3ZhF5In+26vGtcasgSXkd/LC9TElCOc=";
        };
      }
      {
        name = "alias-tips";
        src = pkgs.fetchFromGitHub {
          owner = "djui";
          repo = "alias-tips";
          rev = "master";
          sha256 = "sha256-ZFWrwcwwwSYP5d8k7Lr/hL3WKAZmgn51Q9hYL3bq9vE=";
        };
      }
    ];
    prezto = {
      enable = true;
      pmodules = [
        "gnu-utility"
        "utility"
        "git"
        "directory"
        "terminal"
        "editor"
        "environment"
        "history"
        "completion"
        "spectrum"
      ];
      terminal.autoTitle = true;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    settings = { shlvl.disabled = false; };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";
    font = {
      package = pkgs.fira-code;
      name = "Fira Code";
    };
    settings = {
      scrollback_lines = 16384;
      notify_on_cmd_finish = "unfocused";
    };
    # it doesn't appear to pick the right font for symbols
    # source: https://github.com/ryanoasis/nerd-fonts/issues/1189#issuecomment-1536112595
    extraConfig = ''
      # Seti-UI + Custom
      symbol_map U+E5FA-U+E6AC Symbols Nerd Font Mono
      # Devicons
      symbol_map U+E700-U+E7C5 Symbols Nerd Font Mono
      # Font Awesome
      symbol_map U+F000-U+F2E0 Symbols Nerd Font Mono
      # Font Awesome Extension
      symbol_map U+E200-U+E2A9 Symbols Nerd Font Mono
      # Material Design Icons
      symbol_map U+F0001-U+F1AF0 Symbols Nerd Font Mono
      # Weather
      symbol_map U+E300-U+E3E3 Symbols Nerd Font Mono
      # Octicons
      symbol_map U+F400-U+F532,U+2665,U+26A1 Symbols Nerd Font Mono
      # Powerline Symbols
      symbol_map U+E0A0-U+E0A2,U+E0B0-U+E0B3 Symbols Nerd Font Mono
      # Powerline Extra Symbols
      symbol_map U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D4 Symbols Nerd Font Mono
      # IEC Power Symbols
      symbol_map U+23FB-U+23FE,U+2B58 Symbols Nerd Font Mono
      # Font Logos
      symbol_map U+F300-U+F32F Symbols Nerd Font Mono
      # Pomicons
      symbol_map U+E000-U+E00A Symbols Nerd Font Mono
      # Codicons
      symbol_map U+EA60-U+EBEB Symbols Nerd Font Mono
      # Heavy Angle Brackets
      symbol_map U+E276C-U+2771 Symbols Nerd Font Mono
      # Box Drawing
      symbol_map U+2500-U+259F Symbols Nerd Font Mono
    '';
  };

  programs.wezterm = {
    enable = true;
    extraConfig = let
      config = pkgs.stdenv.mkDerivation {
        name = "wezterm-config";
        buildInputs = [ pkgs.fennel ];
        src = ../config/wezterm.fnl;
        phases = [ "buildPhase" ];
        buildPhase = ''
          mkdir -p $out
          fennel --compile --require-as-include $src > $out/wezterm.lua
        '';
      };
    in "return dofile '${config}/wezterm.lua'";
  };

  programs.eza = { enable = true; };

  programs.broot = { enable = true; };

  # currently broken
  manual.manpages.enable = false;

  # disabled until i can get it working
  # programs.firefox = {
  # enable = true;
  # profiles."m8ralpyk.default" = {
  # userChrome = ''
  # '';
  # };
  # };
}
