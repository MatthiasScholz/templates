{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/packages/
  # TODO find a way to incorporate the package definition and more of the flake.nix
  packages = [
    # FIXME package broken on darwin
    #pkgs.open-policy-agent
    # Test hcl directly with opa because of better debugging capabilities than conftest
    pkgs.hcl2json
    # Linter
    pkgs.regal
    # Testing
    pkgs.conftest
  ];

  # Module introduction
  enterShell = ''
    echo INFO :: opa environment setup
    #echo "opa version $(opa --version)"
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    #opa --version | grep --color=auto "${pkgs.open-policy-agent.version}"
  '';
}
