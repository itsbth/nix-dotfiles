{ darwin, home-manager, ... }: darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  modules = [
    ./configuration.nix
    { networking.hostName = "Bjrns-MBP"; }
    ../../modules/overlays.nix
    home-manager.darwinModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.itsbth = {
          imports = [ ../../modules/home.nix ];
        };
      };
    }
    ../../modules/yabai.nix
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
}
