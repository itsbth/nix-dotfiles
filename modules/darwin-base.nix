{
  config,
  pkgs,
  lib,
  ...
}:

{
  users.users.itsbth = {
    home = "/Users/itsbth";
    # desc = "Bjørn Tore Håvie";
  };

  system.primaryUser = "itsbth";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # Put gui apps here to make them available in spotlight
  environment.systemPackages = [
    pkgs.zstd

    pkgs.neovim
    # pkgs.kitty
    pkgs.vscode

    pkgs.nixpkgs-fmt

    ## Sticking to toolbox for now; easier to install/uninstall; 
    ## too large to justify keeeping always installed; #1 problematic packages
    # pkgs.jetbrains.goland
    # pkgs.jetbrains.webstorm
    # pkgs.jetbrains.clion
    # pkgs.jetbrains.pycharm
    # pkgs.jetbrains.idea
    # not currently packaged
    # pkgs.jetbrains.fleet
    # pkgs.jetbrains.toolbox

    pkgs.iterm2

    # ALL THE CONTAINERS (TODO: Trim this list)
    # pkgs.podman
    pkgs.qemu # needed for podman machine
    pkgs.colima
    (pkgs.lima.override { withAdditionalGuestAgents = true; })
    pkgs.docker-client
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "vscode"
      "slack"

      "goland"
      "webstorm"
      "clion"
      "pycharm"
      "idea"
      # "fleet"
      # "toolbox"
    ];

  fonts = {
    packages = [
      # temporarily disabled while i try to figure out why it's seemingly outdated
      # (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    ];
  };

  nix.package = pkgs.nixVersions.latest;
  nix.settings."extra-experimental-features" = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.enable = true; # default shell on catalina

  system.stateVersion = 4;
}
