{
  description = "itsbth's darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs-channels/nixpkgs-unstable";
    main.url = "github:nixos/nixpkgs";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "main";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }@inputs: {
    # TODO: Figure out why this keeps changing
    darwinConfigurations."Bjrns-MBP" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        {
          nixpkgs.overlays = [
            (self: super: {
              myougiden = self.callPackage ./packages/myougiden {
                inherit (self.python3.pkgs) buildPythonPackage buildPythonApplication fetchPypi;
              };
              httpie = super.httpie.overrideAttrs (old: {
                doCheck = false;
              });
            })
          ];
        }
        ./configuration.nix
        # Has finally been merged into nix-darwin
        # ./modules/pam.nix
        # ./modules/mac.nix
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

        ({ pkgs, ... }: {
          security.pam.enableSudoTouchIdAuth = true;

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
          services.skhd = {
            enable = true;
            skhdConfig = builtins.readFile ./config/skhdrc;
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
