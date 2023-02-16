{ nixpkgs, hyprland, ... }: nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix

    ../../modules/k3s.nix

    ../../modules/hyprland.nix
  ];
}
