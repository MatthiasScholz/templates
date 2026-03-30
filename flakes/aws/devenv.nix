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
    # Custom
    pkgs.gossm
    pkgs.sm
  ];

  overlays = [
    (final: prev: {
      gossm = prev.buildGoModule {
        pname = "gossm";
        version = "69577c1813be5fc0feebf84bb9b11d04018f505f";
        src = prev.fetchFromGitHub {
          owner = "gjbae1212";
          repo = "gossm";
          rev = "69577c1813be5fc0feebf84bb9b11d04018f505f";
          hash = "sha256-Q3RqXdKELcmS2XrjUMJr7JXLpWay22to7Bl7t9+8M/M=";
        };
        vendorHash = "sha256-Yz7acMdbZLeF43kWTkYmPcgBH3eisThZFfdzhrSOYWw=";
        subPackages = [ "cmd/" ];
      };
      sm = prev.buildGoModule {
        pname = "sm";
        version = "244973d5929a67e105790e3b8cda06372a04475e";
        src = prev.fetchFromGitHub {
          owner = "clok";
          repo = "sm";
          rev = "244973d5929a67e105790e3b8cda06372a04475e";
          hash = "sha256-p6qzyBytofwTaGzB4NY+x+WeeepA9J66RU2QSbp4M1c=";
        };
        vendorHash = "sha256-SmZEum/k75jXkmmWgQkdP5rBfoqP2O6t7ASQrJ7x9s4=";
        subPackages = [ "cmd" ];
      };
    })
  ];

  # Aliases
  scripts.identity = {
    exec = "aws sts get-caller-identity";
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
