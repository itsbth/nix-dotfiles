{
  description = "itsbth's darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # main.url = "github:nixos/nixpkgs";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";

    # Fix VSCode server on nixos
    vscode-server.url = "github:msteen/nixos-vscode-server";
  };

  outputs = { self, darwin, nixpkgs, home-manager, hyprland, ... }@inputs: {
    nixosConfigurations.nixos = import ./hosts/nixos {
      inherit (inputs) nixpkgs home-manager hyprland vscode-server;
    };
    # TODO: Figure out why this keeps changing
    darwinConfigurations."Bjrns-MBP" = import ./hosts/Bjrns-MBP {
      inherit darwin home-manager nixpkgs;
    };
    darwinConfigurations."itsbth-mbp16" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      networking.hostName = "itsbth-mbp16";
      modules = [
        ./hosts/Bjrns-MBP/configuration.nix
        { networking.hostName = "itsbth-mbp16"; }
        ./modules/overlays.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.itsbth = {
              imports = [ ./modules/home.nix ];
            };
          };
        }
        ./modules/yabai.nix
        ({ pkgs, ... }: {
          security.pam.enableSudoTouchIdAuth = true;

          programs.gnupg.agent = {
            enable = true;
            enableSSHSupport = true;
          };
        })
      ];
    };
  };
}
