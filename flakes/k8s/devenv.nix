{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  overlays = [
    (final: prev: {
      go = prev.go_1_25;
      kratix-cli = (final.buildGoModule.override { go = final.go; }) {
        pname = "kratix-cli";
        version = "unstable-2026-03-30";
        src = prev.fetchFromGitHub {
          owner = "syntasso";
          repo = "kratix-cli";
          rev = "3f75baeb481f5fd8dc6d4462164cda578f7302e4";
          hash = "sha256-3hRSHO1Hmz7jAlRW3d3qki1JcfDx323bjnCwjUqSZPU=";
        };
        vendorHash = "sha256-UXQoxRsjIM7VjluSm0zM2etPMDMpcbqF/FqsdOhasUM=";
        subPackages = [ "cmd/kratix" ];
      };
    })
  ];

  # https://devenv.sh/packages/
  packages = [
    pkgs.kubectl
    pkgs.kubernetes-helm
    # Simplify YAML handling
    pkgs.yq-go
    # Local Development using KinD
    pkgs.kind
    # .Kratix local development
    #pkgs.minio-client
    # .docker - FIXME on MacOS brew version of docker has to be used, why?
    pkgs.colima
    # Tooling
    # .Cluster Management
    pkgs.k9s
    pkgs.lens
    pkgs.kratix-cli
  ];

  # TODO Run tasks on startup
  # Shell completions
  tasks."zsh:kubectl" = {
    exec = "source <(kubectl completion zsh)";
  };
  tasks."zsh:kratix" = {
    exec = "source <(kratix completion zsh)";
  };

  # Module introduction
  enterShell = ''
    echo INFO :: k8s environment setup
    echo "kubectl version:"
    kubectl version --client
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    kubectl version --client | grep Client | grep --color=auto "${pkgs.kubectl.version}"
  '';
}
