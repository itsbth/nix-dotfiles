{ config, pkgs, lib, ... }:

{
  users.users.itsbth = {
    home = "/Users/itsbth";
    # desc = "Bjørn Tore Håvie";
    /* shell = pkgs.zsh; */
  };
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # Put gui apps here to make them available in spotlight
  environment.systemPackages =
    [
      pkgs.neovim
      pkgs.kitty
      pkgs.vscode

      pkgs.nixpkgs-fmt

      pkgs.slack
      pkgs.jetbrains.goland
      pkgs.jetbrains.webstorm

      pkgs.iterm2
    ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
    "slack"

    "goland"
    "webstorm"
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
