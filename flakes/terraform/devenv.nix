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
    # Version management
    pkgs.tfswitch
    # Orchestration
    pkgs.terramate
    # Analytics
    pkgs.tf-summarize
    # Static Code Analysis
    pkgs.tflint
    pkgs.tfsec
    pkgs.trivy
    # Testing
    pkgs.conftest
    # Documentation
    pkgs.terraform-docs
    # Helper
    pkgs.hcledit
  ];

  # Aliases
  # .terraform
  scripts.tf.exec = ''
    terraform "$@"
  '';
  scripts.tfp.exec = ''
    tf plan -out=infra.tfplan && tf-summarize -tree infra.tfplan
  '';
  # .terramate
  scripts.tm.exec = ''
    terramate "$@"
  '';
  scripts.tmg.exec = ''
    tm generate "$@"
  '';
  scripts.tmp.exec = ''
    tm run -- tmp
  '';
  scripts.tms.exec = ''
    tm script run "$@"
  '';

  # Module introduction
  enterShell = ''
    echo INFO :: terraform environment setup
    echo "terramate version $(terramate --version)"
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    terramate --version | grep --color=auto "${pkgs.terramate.version}"
  '';
}
