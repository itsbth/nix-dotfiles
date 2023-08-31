{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }: {
  home.stateVersion = "21.11";
  home.packages = with pkgs; [
    nixfmt

    devbox # declarative environments

    # nvim + config stuff
    neovim
    fennel
    fnlfmt

    rnix-lsp

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

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Code/github.com/itsbth/dotfiles/nvim/.config/nvim";
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
    includes = [
      {
        path = pkgs.writeText "work.inc" ''
          [user]
            email = bth@neowit.io
        '';
        condition = "gitdir:~/Code/gitlab.com/neowit/";
      }
    ];
    extraConfig = {
      ghq.root = "~/Code";
      url."git@github.com:itsbth/".insteadOf = "https://github.com/itsbth/";
      push.autoSetupRemote = true;
    };
  };

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      sync_address = "https://atuin.itsbth.party";
    };
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting = {
      enable = true;
    };
    shellAliases = { };
    initExtra = ''
      bindkey -e
      take() { mkdir -p "$@" && cd "$@" }

      if [[ ! -z "$ITERM_SESSION_ID" ]]; then
        source ${ ../config/iterm2_shell_integration.zsh }
      fi

      local to_wrap=(wget)
      for cmd ( $to_wrap ); do
        if [[ -z $+commands[$cmd] ]]; then
          eval "function $cmd() { nix shell nixpkgs\#$cmd -c $cmd \"\$@\"; }"
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
    settings = {
      shlvl.disabled = false;
    };
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
  };

  programs.wezterm = {
    enable = true;
    extraConfig =
      let
        config = pkgs.stdenv.mkDerivation {
          name = "wezterm-config";
          buildInputs = [ pkgs.fennel ];
          src = ../config/wezterm.fnl;
          phases = [ "buildPhase" ];
          buildPhase = ''
            mkdir -p $out
            fennel --compile $src > $out/wezterm.lua
          '';
        };
      in
      "return dofile '${config}/wezterm.lua'";
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs.broot = {
    enable = true;
  };

  # currently broken
  manual.manpages.enable = false;

  # disabled until i can get it working
  /* programs.firefox = { */
  /*   enable = true; */
  /*   profiles."m8ralpyk.default" = { */
  /*     userChrome = '' */
  /*     ''; */
  /*   }; */
  /* }; */
}
