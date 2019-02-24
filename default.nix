let
  nixpkgs = import <nixpkgs> {};
in with nixpkgs;
rec {
  gcc-xtensa = callPackage ./esp32-toolchain {};
  esp-idf = callPackage ./esp-idf { };
  micropython-esp32 = callPackage ./micropython { inherit gcc-xtensa esp-idf; };
  flash-micropython-esp32 = writeScriptBin "flash-micropyton-esp32" ''
    PORT=$1
    if [[ -z "$PORT" ]]; then
      PORT=/dev/ttyUSB0
    fi
    ${esptool}/bin/esptool.py --chip esp32 --port $PORT --baud 115200 write_flash -z 0x1000 ${micropython-esp32}/firmware.bin
  '';
}
