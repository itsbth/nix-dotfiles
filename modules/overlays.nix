{
  nixpkgs.overlays = [
    (self: super: {
      myougiden = self.callPackage ../packages/myougiden { };
      fennel-ls = self.callPackage ../packages/fennel-ls { };
      kitty = super.kitty.overrideAttrs (old: { doCheck = false; doInstallCheck = false; });
    })
  ];
}
