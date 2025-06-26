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
    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos = import ./hosts/nixos {
      inherit (inputs) nixpkgs home-manager vscode-server;
    };
    darwinConfigurations."itsbth-mbp13" =
      import ./hosts/itsbth-mbp13 { inherit darwin home-manager nixpkgs; };
    darwinConfigurations."itsbth-mbp16" =
      import ./hosts/itsbth-mbp16 { inherit darwin home-manager nixpkgs; };
  };
}
