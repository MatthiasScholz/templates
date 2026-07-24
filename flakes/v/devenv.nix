{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  packages = [
    # Language
    pkgs.vlang
    # LSP
    # TODO Add support for v-analyzer (superseed of vls), currently no package available
    # https://github.com/vlang/v-analyzer
    # Installable via:
    # v download -RD https://raw.githubusercontent.com/vlang/v-analyzer/main/install.vsh
  ];

  # Module introduction
  enterShell = ''
    echo INFO :: javascript, typescript, node environment setup
    echo "v version: $(v -v)"
  '';

  scripts.setup-v-analyzer.description = "Installs the vlang LSP using native tooling as workaround.";
  scripts.setup-v-analyzer.exec = ''
    v download -RD https://raw.githubusercontent.com/vlang/v-analyzer/main/install.vsh
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    v -v | grep --color=auto "${pkgs.vlang.version}"
  '';
}
