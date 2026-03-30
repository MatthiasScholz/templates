# TODO consider renaming to "scripting"
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
      # NOTE Ensure no v2 version is used - missing devops tooling
      risor = prev.risor.overrideAttrs (oldAttrs: {
        version = "full-v1.8.1";
        tags = (oldAttrs.tags or [ ]) ++ [
          "aws"
          "carbon"
          "cli"
          "jmespath"
          "k8s"
          "pgx"
          "semver"
          "s3fs"
          "template"
          "uuid"
        ];
        vendorHash = "sha256-yVvryqPB35Jc3MXIJyRlFhAHU8H8PmSs60EO/JABHDs=";
      });
      rsx = prev.buildGoModule {
        pname = "rsx";
        version = "unstable-2026-03-29";
        src = prev.fetchFromGitHub {
          owner = "rubiojr";
          repo = "rsx";
          rev = "73352872ce15fed16691beb1086130af2a96282f";
          hash = "sha256-FF8IiYWAEH5fXkfv66Zsw3A8cSvVGFV5i+vioUlbrt8=";
        };
        vendorHash = "sha256-ashPcaBOy8bJ0n9NUQCWTeOD5Q3a/FqIh60516csqjY=";
        tags = [
          "fts5"
          "semver"
        ];
        env.CGO_ENABLED = "1";
        buildInputs = [
          prev.sqlite
        ]
        ++ prev.lib.optionals prev.stdenv.isDarwin [ prev.apple-sdk_14 ];
      };
    })
  ];

  languages.shell.enable = true;

  # https://devenv.sh/packages/
  packages = [
    # Scripting Languages - uses the overlays
    pkgs.risor
    pkgs.rsx
    # Static Code Analysis
    pkgs.shellcheck
    pkgs.shfmt
    # Testing
    pkgs.bats
    # Development Environment
    pkgs.bash-language-server
    # Helper libraries and tools
    pkgs.gum
  ];

  # Completion
  # FIXME compdef: command not found
  tasks."zsh:risor" = {
    exec = "source <(risor completion zsh)";
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
    risor -c 'import aws; print("aws ok")'
    rsx version
  '';
}
