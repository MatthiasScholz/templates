# NOTE: Copy of https://github.com/the-nix-way/dev-templates/blob/main/hashi/flake.nix
{
  description = "A Nix-flake-based development environment for shell scripting";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      # Need go compiler to install some handy tools not available in the nixpkgs
      goVersion = 24;
      overlays = [
        (final: prev: {
          go = prev."go_1_${toString goVersion}";
          risor = prev.risor.overrideAttrs (oldAttrs: {
            buildFlags = [ "-tags=aws,carbon,cli,jmespath,k8s,pgx,semver,s3fs,template,uuid" ];
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
            buildInputs = [ prev.sqlite ] ++ prev.lib.optionals prev.stdenv.isDarwin [ prev.apple-sdk_14 ];
          };
        })
      ];
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system: f { pkgs = import nixpkgs { inherit overlays system; }; }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # linting
              shellcheck
              shfmt
              # testing
              bats
              # debugger, in emacs via realgud - darwin unsupported -> use brew
              # bashdb
              # language server
              bash-language-server
              # --- alternatives
              # TODO check if go needs to be installed - if yes: consider moving to golang
              # https://risor.io
              # FIXME does not contain aws, k8s
              risor
              rsx
              # If shell scripting then with style
              gum
              # Prerequisite to install RSX
              # SEE: https://rubiojr.github.io/rsx/
              go
            ];

            # TODO Check
            # https://github.com/direnv/direnv/issues/73#issuecomment-2478178424
            # NOTE Not supported by direnv!
            # https://discourse.nixos.org/t/how-to-define-alias-in-shellhook/15299
            shellHook = ''
              echo "INFO :: Configure autocompletion for Bash"
              source <(risor completion bash)
            '';
          };
        }
      );
    };
}
