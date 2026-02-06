{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/packages/
  packages = [
    pkgs.go-task
    pkgs.mqttx-cli
    pkgs.mqttui
  ];

  # https://devenv.sh/basics/
  enterShell = ''
    echo INFO :: mqtt environment setup
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
  '';

  # See full reference at https://devenv.sh/reference/options/
}
