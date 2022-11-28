{ config, pkgs, lib, ... }:

{
  networking.hostName = "Bjrns-MBP";

  users.users.itsbth = {
    home = "/Users/itsbth";
    # desc = "Bjørn Tore Håvie";
  };
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # Put gui apps here to make them available in spotlight
  environment.systemPackages =
    [
      pkgs.zstd

      pkgs.neovim
      pkgs.kitty
      pkgs.vscode

      pkgs.nixpkgs-fmt

      pkgs.slack
      pkgs.jetbrains.goland
      pkgs.jetbrains.webstorm
      pkgs.jetbrains.clion
      pkgs.jetbrains.pycharm-professional

      pkgs.iterm2

      # ALL THE CONTAINERS (TODO: Trim this list)
      pkgs.podman
      pkgs.qemu # needed for podman machine
      pgks.colima
      pkgs.docker
    ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
    "slack"

    "goland"
    "webstorm"
    "clion"
    "pycharm-professional"
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
