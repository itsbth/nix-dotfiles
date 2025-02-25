{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }: {
  home.stateVersion = "21.11";
  home.packages = with pkgs; [
    nixfmt-rfc-style

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

    # build broken
    # bitwarden-cli

    # rather not have them global, but it simplifies some stuff for now
    nodejs

    rustup # :/
    # let's try some gui apps now that we're using raycast
    # github-desktop # not packaged for silicon yet
    # mpv

    git-absorb

    # install at user-level, not per-project to reduce headaches
    (google-cloud-sdk.withExtraComponents
      [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
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
      contents = { user.email = "bth@neowit.io"; };
      condition = "gitdir:~/Code/gitlab.com/neowit/";
    }];
    extraConfig = {
      ghq.root = "~/Code";
      url."git@github.com:itsbth/".insteadOf = "https://github.com/itsbth/";

      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      init.defaultBranch = "main";

      diff.algorithm = "histogram";
      diff.colorMoved = "plain";
      diff.mnemonicPrefix = true;
      diff.renames = true;

      push.default = "simple";
      push.autoSetupRemote = true;
      push.followTags = true;

      fetch.prune = true;
      fetch.pruneTags = true;
      fetch.all = true;

      help.autocorrect = 1;
      commit.verbose = true;

      rerere.enabled = true;
      rerere.autoUpdate = true;

      rebase.autoSquash = true;
      rebase.autoStash = true;
      rebase.updateRefs = true;

      core.fsmonitor = true;
      core.untrackedCache = true;

      merge.conflictstyle = "zdiff3";

      pull.rebase = true;
      pull.ff = "only";
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
      # not needed with starship prompt (is there a better place to set this?)
      export VIRTUAL_ENV_DISABLE_PROMPT=1
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
    # theme = "Tokyo Night";
    themeFile = "tokyo_night_night";
    font = {
      package = pkgs.fira-code;
      name = "Fira Code";
    };
    settings = {
      scrollback_lines = 16384;
      notify_on_cmd_finish = "unfocused";
      allow_remote_control = true;
    };
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
