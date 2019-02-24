{ buildPythonPackage, fetchPypi, pyudev, pyserial }:

buildPythonPackage rec {
  pname = "rshell";
  version = "0.0.11";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19i1vvqn9isfxqc5qrh4wyi6353x79b8nhj6nrzql6v8a584408q";
  };

  propagatedBuildInputs = [pyudev pyserial];
}

