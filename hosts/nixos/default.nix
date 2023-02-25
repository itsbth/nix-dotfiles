{ nixpkgs, hyprland, vscode-server, ... }: nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix

    ../../modules/k3s.nix

    hyprland.nixosModules.default
    ../../modules/hyprland.nix

    vscode-server.nixosModule
    ({ config, pkgs, ... }: {
      services.vscode-server.enable = true;
    })
  ];
}
