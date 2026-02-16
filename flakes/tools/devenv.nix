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
    # Task execution
    pkgs.gnumake
    pkgs.go-task
    # Management
    # .multiple git repositories
    pkgs.mani
    # Documentation
    pkgs.adrgen
    # Structured file processing
    pkgs.jq
    pkgs.fx
    # REST API interaction and testing
    pkgs.restish
    pkgs.hurl
    # Secret Management
    pkgs.secretspec
  ];

  # Module introduction
  enterShell = ''
    echo INFO :: tools environment setup
    echo "mani version $(mani --version)"
    echo "task version $(task --version)"
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    mani --version | grep --color=auto "${pkgs.mani.version}"
    task --version | grep --color=auto "${pkgs.go-task.version}"
  '';
}
