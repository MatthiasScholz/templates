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
    # Container Runtime
    pkgs.colima
    pkgs.docker-buildx
    pkgs.docker-compose
    # Development Support
    pkgs.dockerfile-language-server-nodejs
    # Testing
    pkgs.goss
    # TODO darwin currently unsupport, but goss is available and dgoss is only a wrapper
    # TODO extend nixpkgs platforms to mac: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/dg/dgoss/package.nix#L42
    # pkgs.dgoss
    # Tooling
    # .Prepare container build with collecting local files
    pkgs.rsync
    # HACK dgoss installation prerequisite
    pkgs.curl
  ];

  # HACK manually install of dgoss
  tasks."install:dgoss" = {
    exec = ''
         curl -L https://raw.githubusercontent.com/goss-org/goss/master/extras/dgoss/dgoss -o /tmp/dgoss
         chmod +rx /tmp/dgoss
    '';
  };

  # Completion
  tasks."zsh:docker" = {
    exec = ''source <(docker completion zsh)'';
  };

  # Module introduction
  enterShell = ''
    echo INFO :: container environment setup
    colima --version"
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    colima --version | grep --color=auto "${pkgs.colima.version}"
  '';
}
