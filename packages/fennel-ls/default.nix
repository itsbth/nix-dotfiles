{ lib, pkgs, stdenv, fetchgit, ... }:
stdenv.mkDerivation rec {
  pname = "fennel-ls";
  version = "0.1.0";
  src = fetchgit {
    url = "https://git.sr.ht/~xerool/fennel-ls";
    rev = "a29cbe496e7c110b304b0119e7d8b91aa0fa713d";
    hash = "sha256-RW3WFJGwascD4YnnrAm/2LFnVigzgtfzVubLMDW9J5s=";
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
