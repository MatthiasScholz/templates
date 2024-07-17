# NOTE: Copy of https://github.com/the-nix-way/dev-templates/blob/main/hashi/flake.nix
{
  description = "A Nix-flake-based development environment for Terraform";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f { pkgs = import nixpkgs { inherit system; }; });
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              tfswitch
              tf-summarize
              # Orchestrate
              terramate
              # Static code analysis
              tflint
              # Deprecated
              tfsec
              # Superseeded by
              trivy
              # Helper
              hcledit
              # Custom policies
              conftest
            ];

            # NOTE Not supported by direnv!
            # https://discourse.nixos.org/t/how-to-define-alias-in-shellhook/15299
            #shellHook = ''
            #    alias tmg="terramate generate"
            #'';
          };
        }
      );
    };
}
