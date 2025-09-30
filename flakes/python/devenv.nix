{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # NOTE Not using languages.python because it adds an input dependency
  #      which needs to be specified by the user of the module.
  #      This is error prone and inconvenient.
  # https://devenv.sh/packages/
  packages = [
    # Language
    pkgs.python313
    # Package Managerment
    pkgs.uv
    # Static Code Analysis
    pkgs.python313Packages.pyflakes
    pkgs.black
    pkgs.isort
    # Testing
    pkgs.python313Packages.pytest
    # Development Support
    pkgs.python313Packages.python-lsp-server
    pkgs.pyright
    # Tooling
    # .Templating
    pkgs.jinja2-cli
  ];

  # Module introduction
  enterShell = ''
    echo INFO :: python environment setup
    echo "python version $(python --version)"
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    python --version | grep --color=auto "${pkgs.python.version}"
  '';
}
