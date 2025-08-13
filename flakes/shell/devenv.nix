# TODO consider renaming to "scripting"
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  languages.shell.enable = true;

  # https://devenv.sh/packages/
  packages = [
    # Scripting Languages
    pkgs.risor
    # Static Code Analysis
    pkgs.shellcheck
    pkgs.shfmt
    # Testing
    pkgs.bats
    # Development Environment
    pkgs.bash-language-server
    # Helper libraries and tools
    pkgs.gum
    # HACK for custom risor build
    pkgs.git
  ];

  # HACK recompile risor to enable additional modules
  #      currently nixpkgs does not offer a full version
  languages.go.enable = true;
  # Build risor with all available modules"
  tasks."risor:full" = {
    exec = ''
         TMPDIR_RISOR=$(mktemp -d --tmpdir=/tmp)
         echo ".build folder: $TMPDIR_RISOR"
         git clone https://github.com/risor-io/risor.git $TMPDIR_RISOR
         cd $TMPDIR_RISOR
         go install -tags=aws,carbon,cli,jmespath,k8s,pgx,semver,s3fs,template,uuid .
    '';
  };
  # Setup risor script bundler with external library support: RSX"
  tasks."risor:rsx" = {
    exec = ''CGO_ENABLED=1 go install --tags fts5,semver github.com/rubiojr/rsx@latest'';
  };

  # Completion
  # FIXME compdef: command not found
  tasks."zsh:risor" = {
    exec = ''source <(risor completion zsh)'';
  };

  # Module introduction
  enterShell = ''
    echo INFO :: shell scripting environment setup
    echo "risor version $(risor version)"
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    risor version | grep --color=auto "${pkgs.risor.version}"
  '';
}
