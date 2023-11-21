{ config, pkgs, lib, ... }:

{
  users.users.itsbth = {
    home = "/Users/itsbth";
    # desc = "Bjørn Tore Håvie";
  };
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # Put gui apps here to make them available in spotlight
  environment.systemPackages = [
    pkgs.zstd

    pkgs.neovim
    # pkgs.kitty
    pkgs.vscode

    pkgs.nixpkgs-fmt

    pkgs.jetbrains.goland
    (pkgs.jetbrains.webstorm.overrideAttrs {
      version = "2023.2.5";
      src = builtins.fetchurl {
        url =
          "https://download.jetbrains.com/webstorm/WebStorm-2023.2.5-aarch64.dmg";
        sha256 =
          "0skl7cqb3hgyz1sd7snsh7xcr54z530dqm7yyiisx1b6bs051p00";
      };
    })
    pkgs.jetbrains.clion
    pkgs.jetbrains.pycharm-professional
    pkgs.jetbrains.idea-ultimate
    # not currently packaged
    # pkgs.jetbrains.fleet
    # pkgs.jetbrains.toolbox

    pkgs.discord
    # pkgs.steam

    pkgs.iterm2

    # ALL THE CONTAINERS (TODO: Trim this list)
    # pkgs.podman
    pkgs.qemu # needed for podman machine
    pkgs.colima
    pkgs.docker-client
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "vscode"
      "slack"

      "goland"
      "webstorm"
      "clion"
      "pycharm-professional"
      "idea-ultimate"
      # "fleet"
      # "toolbox"

      "discord"
      "steam"
    ];

  fonts = {
    fontDir.enable = true;
    fonts = [
      # temporarily disabled while i try to figure out why it's seemingly outdated
      # (pkgs.nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    ];
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nixUnstable;
  nix.settings."extra-experimental-features" = [ "nix-command" "flakes" ];

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
