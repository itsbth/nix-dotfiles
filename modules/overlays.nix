{
  nixpkgs.overlays = [
    (self: super: { myougiden = self.callPackage ../packages/myougiden { }; })
    # e2e pty tests time out in the darwin sandbox (atuin 18.23.0)
    (self: super: {
      atuin = super.atuin.overrideAttrs (old: {
        checkFlags = (old.checkFlags or [ ]) ++ [
          "--skip=filtered_commands_leave_no_captured_output"
          "--skip=bash_preexec"
        ];
      });
    })
  ];
}
