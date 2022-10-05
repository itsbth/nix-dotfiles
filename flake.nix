{
  description = "itsbth's darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs-channels/nixos-unstable";
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

  outputs = { self, darwin, nixpkgs, main, home-manager, ... }@inputs: {
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
              kitty = super.kitty.overrideAttrs (fin: prev: {
                doInstallCheck = false;
              });
              # bump neovim
              /* neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (old: rec { */
              /*   version = "0.8.0"; */
              /*   src = self.fetchFromGitHub { */
              /*     owner = "neovim"; */
              /*     repo = "neovim"; */
              /*     rev = "v${version}"; */
              /*     sha256 = "sha256-mVeVjkP8JpTi2aW59ZuzQPi5YvEySVAtxko7xxAx/es="; */
              /*   }; */
              /* }); */
              /* libvterm-neovim = super.libvterm-neovim.overrideAttrs (old: rec { */
              /*   version = "0.3"; */
              /*   src = self.fetchurl { */
              /*     url = "https://www.leonerd.org.uk/code/libvterm/libvterm-${version}.tar.gz"; */
              /*     sha256 = "sha256-YesNZijFK98CkA39RGiqhqGnElIourimcyiYGIdIM1g="; */
              /*   }; */
              /* }); */
              yabai = self.darwin.apple_sdk_11_0.callPackage ./packages/yabai {
                inherit (self.darwin.apple_sdk.frameworks) Cocoa Carbon ScriptingBridge;
                inherit (self.darwin.apple_sdk_11_0.frameworks) SkyLight;
              };
            })
          ];
        }
        ./configuration.nix
        # Has finally been merged into nix-darwin
        # ./modules/pam.nix
        ./modules/mac.nix
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
