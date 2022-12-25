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
    userName = "Bjørn Tore Håvie";
    userEmail = "bjoern.tore.haavie@pexip.com";
    delta = {
      enable = true;
    };
    ignores = [ ".vim" ".direnv" ];
    includes = [
      {
        path = pkgs.writeText "personal.inc" ''
          [user]
            email = itsbth@itsbth.com
        '';
        condition = "gitdir:~/Code/github.com/itsbth/";
      }
    ];
    extraConfig = {
      ghq.root = "~/Code";
      url."git@github.com:itsbth/".insteadOf = "https://github.com/itsbth/";
      url."git@github.com:pexip/".insteadOf = "https://github.com/pexip/";
      url."git@gitlab.com:pexip/".insteadOf = "https://gitlab.com/pexip/";
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
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";
    font = {
      package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
      name = "FiraCode Nerd Font Mono";
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
