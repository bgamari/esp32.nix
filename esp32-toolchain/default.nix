{ lib, stdenv, ncurses5, zlib }:

stdenv.mkDerivation {
  name = "esp32-toolchain";
  src = fetchTarball {
    url = https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz;
    sha256 = "1fxwsc47fxq5cyn51v949b030vnp4j75f8vlvlfyhv8l1qalvxbs";
  };
  buildInputs = [ ncurses5 zlib ];
  installPhase = ''
    mkdir -p $out
    cp -ra * $out
  '';
  preferLocalBuild = true;
  postFixup = 
    let
      libPath = 
        lib.makeLibraryPath [
          ncurses5 
          stdenv.cc.cc.lib # libstdc++
          zlib
        ];
    in ''
    PROGS="
      addr2line
      ar
      as
      c++
      cc
      c++filt
      cpp
      elfedit
      g++
      gcc
      gcc-5.2.0
      gcc-ar
      gcc-nm
      gcc-ranlib
      gcov
      gcov-tool
      gdb
      gprof
      ld
      ld.bfd
      nm
      objcopy
      objdump
      ranlib
      readelf
      size
      strings
      strip"
    for prog in $PROGS; do
      prog="$out/bin/xtensa-esp32-elf-$prog"
      echo "Patching $prog"
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $prog
    done

    for prog in liblto_plugin.so; do
      prog="$out/libexec/gcc/xtensa-esp32-elf/5.2.0/$prog"
      echo "Patching $prog"
      patchelf \
        --set-rpath "${libPath}" \
        $prog
    done

    for prog in cc1 cc1plus collect2 lto1 lto-wrapper; do
      prog="$out/libexec/gcc/xtensa-esp32-elf/5.2.0/$prog"
      echo "Patching $prog"
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $prog
    done

    for prog in ar as ld ld.bfd nm objcopy objdump ranlib strip; do
      prog="$out/xtensa-esp32-elf/bin/$prog"
      echo "Patching $prog"
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $prog
    done
  '';
}
