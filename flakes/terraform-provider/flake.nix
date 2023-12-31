# NOTE Copy from:https://github.com/the-nix-way/dev-templates/blob/main/go/flake.nix
{
  description = "A Nix-flake-based Go development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      goVersion = 21;
      overlays = [ (final: prev: { go = prev."go_1_${toString goVersion}"; }) ];
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit overlays system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
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
          ];

          shellHook = ''
            go install github.com/hashicorp/terraform-plugin-codegen-framework/cmd/tfplugingen-framework@latest
            go install github.com/hashicorp/terraform-plugin-codegen-openapi/cmd/tfplugingen-openapi@latest
            '';
        };
      });
    };
}
