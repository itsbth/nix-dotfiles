{ pkgs, lib, config, home-manager, nix-darwin, inputs, ... }: {
  home.stateVersion = "21.11";
  home.packages = with pkgs; [
    nixfmt

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

    myougiden

    bitwarden-cli

    # rather not have them global, but it simplifies some stuff for now
    nodejs
    cargo

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
    delta = {
      enable = true;
    };
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
    };
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
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
    plugins = [{
      name = "zsh-fzf-ghq";
      src = pkgs.fetchFromGitHub {
        owner = "itsbth";
        repo = "zsh-fzf-ghq";
        rev = "master";
        hash = "sha256-4y19nUEKBPPe3ZhF5In+26vGtcasgSXkd/LC9TElCOc=";
      };
    }];
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

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  # disabled until i can get it working
  /* programs.firefox = { */
  /*   enable = true; */
  /*   profiles."m8ralpyk.default" = { */
  /*     userChrome = '' */
  /*     ''; */
  /*   }; */
  /* }; */
}
