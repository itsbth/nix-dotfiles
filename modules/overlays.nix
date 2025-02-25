{
  nixpkgs.overlays = [
    (self: super: { myougiden = self.callPackage ../packages/myougiden { }; })
  ];
}
