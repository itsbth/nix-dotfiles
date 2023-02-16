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
  };

  outputs = { self, darwin, nixpkgs, home-manager, hyprland, ... }@inputs: {
    nixosConfigurations.nixos = import ./hosts/nixos {
      inherit nixpkgs;
    };
    # TODO: Figure out why this keeps changing
    darwinConfigurations."Bjrns-MBP" = import ./hosts/Bjrns-MBP {
      inherit darwin home-manager nixpkgs hyprland;
    };
  };
}
