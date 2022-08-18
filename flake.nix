{
  description = "itsbth's darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, darwin, nixpkgs, home-manager }: {
    darwinConfigurations."Bjrns-MBP" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./configuration.nix
        ./modules/pam.nix
        ./modules/mac.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.itsbth = {
              # home = "/Users/itsbth";
              imports = [ ./modules/home.nix ];
            };
          };
        }

        ({ pkgs, ... }: {
          security.pam.enableSudoTouchIdAuth = true;
          services.nix-daemon.enable = true;
          services.yabai = {
            enable = true;
            package = pkgs.yabai;
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

          programs.gnupg.agent = {
            enable = true;
            enableSSHSupport = true;
          };
        })
      ];
    };
  };
}
