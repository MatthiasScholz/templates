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
    pkgs.lua
    # LSP
    # supported by emacs: lsp-mode and eglot
    pkgs.lua-language-server
  ];

  # Module introduction
  enterShell = ''
    echo INFO :: lua environment setup
    echo "lua version $(lua -v)"
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    lua -v | grep --color=auto "${pkgs.lua.version}"
  '';
}
