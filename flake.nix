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

    # Fix VSCode server on nixos
    vscode-server.url = "github:msteen/nixos-vscode-server";
  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos = import ./hosts/nixos {
      inherit (inputs) nixpkgs home-manager vscode-server;
    };
    # TODO: rename this to itsbth-mbp13 for consistency
    darwinConfigurations."itsbth-mbp13" = import ./hosts/itsbth-mbp13 {
      inherit darwin home-manager nixpkgs;
    };
    darwinConfigurations."itsbth-mbp16" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      # networking.hostName = "itsbth-mbp16";
      modules = [
        ./hosts/itsbth-mbp13/configuration.nix
        # { networking.hostName = "itsbth-mbp16"; }
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
        # Breaks way too often
        { documentation.enable = false; }
      ];
    };
  };
}
