{
  config,
  lib,
  pkgs,
  ...
}:

{
  packages = [
    # Test workflows locally
    pkgs.wrkflw
    # Linting
    pkgs.actionlint
  ];

  enterShell = ''
    echo INFO :: github action tooling
    wrkflw --version
    actionlint --version
  '';
}
