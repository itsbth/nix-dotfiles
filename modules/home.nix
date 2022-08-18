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

    glow
    mdcat
  ];
  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Code/github.com/itsbth/dotfiles/nvim/.config/nvim";
  };

  programs.git = {
    enable = true;
    userName = "Bjørn Tore Håvie";
    userEmail = "bjoern.tore.haavie@pexip.com";
    delta = {
      enable = true;
    };
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
    shellAliases = {};
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
    prezto = { enable = true; };
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
    font = {
      package = (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; });
      name = "Fira Code NF";
    };
  };
}
