let
  nixpkgs = import <nixpkgs> {};
in with nixpkgs;
rec {
  gcc-xtensa = callPackage ./esp32-toolchain {};
  esp-idf = callPackage ./esp-idf { };

  micropython-esp32 = micropython-pfalcon-esp32;
  micropython-upstream-esp32 = callPackage ./micropython { inherit gcc-xtensa esp-idf; };
  micropython-pfalcon-esp32 = (callPackage ./micropython { inherit gcc-xtensa esp-idf; }).overrideAttrs (oldAttrs: {
    src = fetchgit {
      url = "https://github.com/pfalcon/micropython";
      rev = "f31d7073931242a75dc6967e86ec522b80baea28";
      sha256 = "1zr95rln32lszv7rbz7sbi4iy149h7g3q2n7isjfa4hblgb2c9qv";
    };
  });

  rshell = python3Packages.callPackage ./rshell {};

  flash-micropython-esp32 = writeScriptBin "flash-micropyton-esp32" ''
    PORT=$1
    if [[ -z "$PORT" ]]; then
      PORT=/dev/ttyUSB0
    fi
    ${esptool}/bin/esptool.py --chip esp32 --port $PORT --baud 115200 write_flash -z 0x1000 ${micropython-esp32}/firmware.bin
  '';
}
