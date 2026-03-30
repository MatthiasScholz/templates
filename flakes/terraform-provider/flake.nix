# NOTE Copy from:https://github.com/the-nix-way/dev-templates/blob/main/go/flake.nix
{
  description = "A Nix-flake-based Go development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      goVersion = 24;
      overlays = [
        (final: prev: {
          go = prev."go_1_${toString goVersion}";
          tfplugingen-framework = prev.buildGoModule {
            pname = "tfplugingen-framework";
            version = "cbeb4a1e0daa8e5c2ff35a3e1d77ae2350bebab4";
            src = prev.fetchFromGitHub {
              owner = "hashicorp";
              repo = "terraform-plugin-codegen-framework";
              rev = "cbeb4a1e0daa8e5c2ff35a3e1d77ae2350bebab4";
              hash = "sha256-Jq4SJG94aYyjEIMD1L6E21DVEf4NrBiIP92uKrJG9Q0=";
            };
            vendorHash = "sha256-1tV57ifsN7FjmADS8JiyyTqtMupZ2YV2mUTPlnajCvQ=";
            subPackages = [ "cmd/tfplugingen-framework" ];
          };
          tfplugingen-openapi = prev.buildGoModule {
            pname = "tfplugingen-openapi";
            version = "3bb8151a29f7917a4a0feb89284264dc39cc71c0";
            src = prev.fetchFromGitHub {
              owner = "hashicorp";
              repo = "terraform-plugin-codegen-openapi";
              rev = "3bb8151a29f7917a4a0feb89284264dc39cc71c0";
              hash = "sha256-WFNVgf/LKVnahUW6UbzGCHhzwfvr0o4uN3e4rj3CytM=";
            };
            vendorHash = "sha256-yyYt+ALmPKAPoNegJd2QdJCeKIeCBq0D+vGegmguiio=";
            subPackages = [ "cmd/tfplugingen-openapi" ];
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
          system:
          f {
            pkgs = import nixpkgs { inherit overlays system; };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # go (specified by overlay)
              go

              # goimports, godoc, etc.
              gopls
              gotools
              gotestsum
              delve

              # https://github.com/golangci/golangci-lint
              golangci-lint

              # terraform-plugin-codegen
              tfplugingen-framework
              tfplugingen-openapi
            ];

            shellHook = "";
          };
        }
      );
    };
}
