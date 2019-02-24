{ stdenv, fetchgit, fetchFromGitHub, makeWrapper, git, 
  gcc-xtensa, esp-idf,
  python3, python3Packages, 
  python2, python2Packages
}:

stdenv.mkDerivation {
  name = "micropython-esp32";
  nativeBuildInputs = [
    git gcc-xtensa 
    python3 python3Packages.pyserial
    python2 python2Packages.pyserial # for gen_esp32part.py 
  ];
  src = fetchFromGitHub {
    name = "micropython";
    owner = "micropython";
    repo = "micropython";
    rev = "5801a003f055a9db6d569fbb0ffc3018dcaa8c3e";
    fetchSubmodules = true;
    sha256 = "1jbwsmpnb6zlkidc5kxp268px8m0iwf6wz2js75cwxsrnbgxk6z4";
  };
  patches = [ ./0001-Rely-on-hashbang-to-invoke-esp-idf-tools.patch ];
  IDF_PATH=esp-idf;
  ESP_IDF=esp-idf;
  buildPhase = ''
    make -C mpy-cross
    make -C ports/esp32 CROSS_COMPILE=xtensa-esp32-elf- V=1
  '';
  installPhase = ''
    mkdir -p $out
    cp ports/esp32/build/bootloader.{bin,map,elf} $out
    cp ports/esp32/build/application.{bin,map,elf} $out
    cp ports/esp32/build/partitions.bin $out
    cp ports/esp32/build/firmware.bin $out
  '';
}
