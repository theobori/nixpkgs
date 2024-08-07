{
  buildPythonPackage,
  fetchPypi,
  lib,
  google-api-core,
  opencensus-context,
}:

buildPythonPackage rec {
  pname = "opencensus";
  version = "0.11.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-y++H2Lh3MGSrYOXCoc7Vi7qjim0FLEGuwiSVjOVE7/I=";
  };

  propagatedBuildInputs = [
    google-api-core
    opencensus-context
  ];

  pythonNamespaces = [ "opencensus.common" ];

  doCheck = false; # No tests in sdist

  pythonImportsCheck = [ "opencensus.common" ];

  meta = with lib; {
    description = "Stats collection and distributed tracing framework";
    homepage = "https://github.com/census-instrumentation/opencensus-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ billhuang ];
  };
}
