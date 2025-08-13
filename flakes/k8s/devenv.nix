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
  ];

  # HACK Install additional tools not available in nixpkgs
  languages.go.enable = true;
  tasks."tools:kratix" = {
    exec = ''go install github.com/syntasso/kratix-cli/cmd/kratix@latest'';
  };

  # TODO Run tasks on startup
  # Shell completions
  tasks."zsh:kubectl" = {
    exec = ''source <(kubectl completion zsh)'';
  };
  tasks."zsh:kratix" = {
    exec = ''source <(kratix completion zsh)'';
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
