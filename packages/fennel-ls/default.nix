{ lib, pkgs, stdenv, fetchgit, ... }:
stdenv.mkDerivation rec {
  pname = "fennel-ls";
  version = "0.1.0";
  src = fetchgit {
    url = "https://git.sr.ht/~xerool/fennel-ls";
    rev = "364d02b90de6e41c40fc31a19665cad20041c63a";
    hash = "sha256-SAu/i3g1jXMCq/gE9nwxvWQ2eE8qGB4mxvVIzypmVOw=";
  };
  buildInputs = [ pkgs.fennel pkgs.lua ];
  buildPhase = ''
    make
  '';
  installPhase = ''
    mkdir -p $out/bin
    make install PREFIX=$out
  '';
  checkPhase = ''
    make test
  '';
  meta = {
    description = "Fennel Language Server";
    homepage = "https://git.sr.ht/~xerool/fennel-ls";
    license = lib.licenses.mit;
  };
}
