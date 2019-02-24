{ buildPythonPackage, fetchPypi, websocket_client, colorama, pyserial }:

buildPythonPackage rec {
  pname = "mpfshell";
  version = "0.9.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vxgf3ydngffj8swm3s48qkq4carf90q898wbw15zf129r7mwmyv";
  };

  propagatedBuildInputs = [websocket_client colorama pyserial];
}

