{
  lib,
  buildPythonPackage,
  pythonOlder,
  pythonAtLeast,
  fetchFromGitHub,
  poetry-core,
  colorlog,
  dataclasses-json,
  nltk,
  numpy,
  pandas,
  psutil,
  py3langid,
  pytestCheckHook,
  python-dateutil,
  scipy,
  toml,
}:
let
  testNltkData = nltk.dataDir (d: [
    d.punkt
    d.punkt-tab
    d.stopwords
  ]);

  version = "0.0.21";
  tag = "v${version}";
in
buildPythonPackage {
  pname = "type-infer";
  inherit version;
  pyproject = true;

  disabled = pythonOlder "3.8" || pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "mindsdb";
    repo = "type_infer";
    inherit tag;
    hash = "sha256-Q5f4WihaT88R+x4jMUuRNBvWglkGdS5oi+o9jOk+tSE=";
  };

  pythonRelaxDeps = [
    "psutil"
    "py3langid"
    "numpy"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    colorlog
    dataclasses-json
    nltk
    numpy
    pandas
    psutil
    py3langid
    python-dateutil
    scipy
    toml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # test hangs
    "test_1_stack_overflow_survey"
  ];

  # Package import requires NLTK data to be downloaded
  # It is the only way to set NLTK_DATA environment variable,
  # so that it is available in pythonImportsCheck
  env.NLTK_DATA = testNltkData;
  pythonImportsCheck = [ "type_infer" ];

  meta = with lib; {
    changelog = "https://github.com/mindsdb/type_infer/releases/tag/${tag}";
    description = "Automated type inference for Machine Learning pipelines";
    homepage = "https://github.com/mindsdb/type_infer";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
