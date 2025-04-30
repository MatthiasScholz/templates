# NOTE Copy fromhttps://github.com/the-nix-way/dev-templates/blob/main/flake.nix
{
  description = "Ready-made templates for easily creating flake-driven environments";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      overlays = [
        (
          final: prev:
          let
            exec = pkg: "${prev.${pkg}}/bin/${pkg}";
          in
          {
            format = prev.writeScriptBin "format" ''
              ${exec "nixpkgs-fmt"} **/*.nix
            '';
            dvt = prev.writeScriptBin "dvt" ''
              if [ -z $1 ]; then
                echo "no template specified"
                exit 1
              fi

              TEMPLATE=$1

              ${exec "nix"} \
                --experimental-features 'nix-command flakes' \
                flake init \
                --template \
                "github:MatthiasScholz/templates#''${TEMPLATE}"
            '';
            update = prev.writeScriptBin "update" ''
              for dir in `ls -d */`; do # Iterate through all the templates
                (
                  cd $dir
                  ${exec "nix"} flake update # Update flake.lock
                  ${exec "nix"} flake check  # Make sure things work after the update
                )
              done
            '';
          }
        )
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
              format
              update
            ];
          };
        }
      );

      packages = forEachSupportedSystem (
        { pkgs }:
        rec {
          default = dvt;
          inherit (pkgs) dvt;
        }
      );
    }

    //

      # NOTE Register new templates here
      {
        templates = rec {

          go = {
            path = ./flakes/go;
            description = "Go (Golang) development environment";
          };

          opa = {
            path = ./flakes/opa;
            description = "Open Policy agent development environment";
          };

          terraform = {
            path = ./flakes/terraform;
            description = "Terraform development environment";
          };

          terraform-provider = {
            path = ./flakes/terraform-provider;
            description = "Terraform Provider development tooling";
          };

          encore = {
            path = ./flakes/encore;
            description = "Encore SDK and tooling";
          };

          tools = {
            path = ./flakes/tools;
            description = "Common tooling";
          };

          aws = {
            path = ./flakes/aws;
            description = "AWS development environment";
          };

          gcp = {
            path = ./flakes/gcp;
            description = "GCP development environment";
          };

          github = {
            path = ./flakes/github;
            description = "Github development environment";
          };

          shell = {
            path = ./flakes/shell;
            description = "Shell scripting development environment";
          };

          mqtt = {
            path = ./flakes/mqtt;
            description = "MQTT development environment";
          };

          k8s = {
            path = ./flakes/k8s;
            description = "Kubernetes platform development environment";
          };

          v = {
            path = ./flakes/v;
            description = "V development environment";
          };

          container = {
            path = ./flakes/container;
            description = "Container development environment";
          };

          dotnet = {
            path = ./flakes/dotnet;
            description = "Dotnet runtime environment";
          };

        };
      };
}
