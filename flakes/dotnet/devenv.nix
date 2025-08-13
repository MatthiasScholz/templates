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
    pkgs.pkgsx86_64Darwin.dotnet-runtime
  ];

  # Module introduction
  enterShell = ''
    echo INFO :: .NET environment setup
    echo "dotnet version $(dotnet --info)"
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    dotnet --info | grep --color=auto "Architecture" | grep --color=auto "x64"
  '';
}
