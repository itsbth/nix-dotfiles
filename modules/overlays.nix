{
  nixpkgs.overlays = [
    (self: super: {
      myougiden = self.callPackage ../packages/myougiden {
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
