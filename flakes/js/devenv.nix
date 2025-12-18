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
    pkgs.nodejs_24
    # LSP
    # supported by emacs: lsp-mode and eglot
    pkgs.typescript-language-server
  ];

  # Module introduction
  enterShell = ''
    echo INFO :: javascript, typescript, node environment setup
    echo "node version $(node -v)"
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    node -v | grep --color=auto "${pkgs.node.version}"
  '';
}
