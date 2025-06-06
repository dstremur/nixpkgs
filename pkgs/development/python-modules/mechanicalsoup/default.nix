{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pytest-httpbin,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "mechanicalsoup";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MechanicalSoup";
    repo = "MechanicalSoup";
    tag = "v${version}";
    hash = "sha256-fu3DGTsLrw+MHZCFF4WHMpyjqkexH/c8j9ko9ZAeAwU=";
  };

  postPatch = ''
    # Is in setup_requires but not used in setup.py
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
    substituteInPlace setup.cfg \
      --replace " --cov --cov-config .coveragerc --flake8" ""
  '';

  propagatedBuildInputs = [
    beautifulsoup4
    lxml
    requests
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-httpbin
    pytest-mock
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "mechanicalsoup" ];

  meta = with lib; {
    description = "Python library for automating interaction with websites";
    homepage = "https://github.com/hickford/MechanicalSoup";
    changelog = "https://github.com/MechanicalSoup/MechanicalSoup/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      jgillich
      fab
    ];
  };
}
