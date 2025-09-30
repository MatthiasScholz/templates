# NOTE: Copy of https://github.com/the-nix-way/dev-templates/blob/main/hashi/flake.nix
{
  description = "A Nix-flake-based development environment for Kubernetes";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      # Need go compiler to install some handy tools not available in the nixpkgs
      goVersion = 24;
      overlays = [ (final: prev: { go = prev."go_1_${toString goVersion}"; }) ];
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
              # Install additional tools not available in nixpkgs
              go
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
              echo "Install Kratix CLI - for platform development use case on top of K8s"
              go install github.com/syntasso/kratix-cli/cmd/kratix@latest
              source <(kratix completion bash)
            '';
          };
        }
      );
    };
}
