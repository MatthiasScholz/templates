# NOTE: Copy of https://github.com/the-nix-way/dev-templates/blob/main/hashi/flake.nix
{
  description = "A Nix-flake-based development environment for Kubernetes";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      # Need go compiler to install some handy tools not available in the nixpkgs
      goVersion = 25;
      overlays = [
        (final: prev: {
          go = prev."go_1_${toString goVersion}";
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
          # SEE https://ryantm.github.io/nixpkgs/builders/special/mkshell/
          default = pkgs.mkShell {
            packages = with pkgs; [
              # THE CLI
              kubectl
              # Simplify YAML handling
              yq-go
              # Local Development using KinD
              kind
              # docker - FIXME on MacOS brew version of docker has to be used, why?
              colima
              # Cluster Management
              k9s
              lens
              # Kratix CLI
              kratix-cli
              # Kratix local development
              minio-client
              # Required to run the Kratix CLI test suite
              kubernetes-helm
            ];

            # TODO Check
            # https://github.com/direnv/direnv/issues/73#issuecomment-2478178424
            # NOTE Not supported by direnv!
            # https://discourse.nixos.org/t/how-to-define-alias-in-shellhook/15299
            shellHook = ''
              source <(kubectl completion bash)
              source <(kratix completion bash)
            '';
          };
        }
      );
    };
}
