{ lib, python3Packages, ... }:
let
  romkan = python3Packages.buildPythonPackage rec {
    pname = "romkan";
    version = "0.2.1";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "a530245a38969704700e0ca8f9cb7158c4ede91c5fd1e24677dbe814cf91f33b";
    };
  };
in
python3Packages.buildPythonApplication rec {
  pname = "myougiden";
  version = "0.8.9";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "3fbadd41fc00808447c88271ca65414f5b7f02e3186e037c576844a5abf0d36a";
  };

  patches = [ ./001-fix-prefix.patch ];

  buildInputs = [ python3Packages.setuptools ];
  propagatedBuildInputs = [ romkan python3Packages.termcolor ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/melissaboiko/myougiden";
    description = "A Japanese/English dictionary for the command line, colorful and full of features.";
    license = licenses.gpl3Only;
  };
}
