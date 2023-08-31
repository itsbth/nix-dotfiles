{
  nixpkgs.overlays = [
    (self: super: {
      myougiden = self.callPackage ../packages/myougiden {
        inherit (self.python3.pkgs) buildPythonPackage buildPythonApplication fetchPypi;
      };
    })
  ];
}
