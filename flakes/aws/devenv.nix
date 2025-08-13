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
    # CLI
    pkgs.awscli2
    pkgs.ssm-session-manager-plugin
    # Tooling
    pkgs.awslogs
    pkgs.awslimitchecker
    pkgs.aws-nuke
    # AMI
    # NOTE requires unfree package support
    pkgs.packer
  ];

  # Aliases
  scripts.identity = {
    exec = ''aws sts get-caller-identity'';
  };

  # Access instances command line
  tasks."install:gossm" = {
    exec = ''go install github.com/gjbae1212/gossm/cmd/@latest'';
  };

  # AWS Secrets Manager interaction
  tasks."install:sm" = {
    exec = ''go install github.com/clok/sm/cmd@latest'';
  };

  # Module introduction
  enterShell = ''
    echo INFO :: aws environment setup
    echo "aws version $(aws --version)"
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    aws --version | grep --color=auto "${pkgs.awscli2.version}"
  '';
}
