{ darwin, home-manager, ... }: darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  modules = [
    {
      nixpkgs.overlays = [
        (self: super: {
          myougiden = self.callPackage ../../packages/myougiden {
            inherit (self.python3.pkgs) buildPythonPackage buildPythonApplication fetchPypi;
          };
          kitty = super.kitty.overrideAttrs (old: {
            doInstallCheck = false;
          });
          delta = super.delta.overrideAttrs (old: {
            doCheck = false;
          });
        })
      ];
    }
    ./configuration.nix
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

    ({ pkgs, ... }: {
      security.pam.enableSudoTouchIdAuth = true;

      services.yabai = {
        enable = true;
        package = pkgs.yabai;
        enableScriptingAddition = true;
        config = {
          focus_follows_mouse = "autoraise";
          mouse_follows_focus = "off";
          window_placement = "second_child";
          window_opacity = "off";
          top_padding = 36;
          bottom_padding = 10;
          left_padding = 10;
          right_padding = 10;
          window_gap = 10;
        };
      };
      services.skhd = {
        enable = true;
        skhdConfig = builtins.readFile ../../config/skhdrc;
      };

      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    })
  ];
}
