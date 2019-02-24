{ stdenv, fetchgit, makeWrapper, python3, python3Packages }:

stdenv.mkDerivation {
  name = "esp-idf";
  src = fetchgit {
    name = "esp-idf";
    url = "https://github.com/espressif/esp-idf";
    leaveDotGit = true;
    rev = "5c88c5996dbde6208e3bec05abc21ff6cd822d26";
    sha256 = "1ka5i8xxinz5f8g33i2wkq5p9fn92dar2b8qlmlhdi19h8vx7cx5";
  };
  buildInputs = [ python3 python3Packages.pyserial python3Packages.pyparsing ];
  nativeBuildInputs = [ python3 python3Packages.wrapPython makeWrapper ];
  pythonPath = with python3Packages; [ pyserial pyparsing ];
  installPhase = ''
    mkdir -p $out
    cp -ra * $out
  '';
  postFixup = ''
    wrapPythonProgramsIn $out/components/esptool_py/esptool "$pythonPath"
    wrapPythonProgramsIn $out/tools/ldgen "$pythonPath"
  '';
}
