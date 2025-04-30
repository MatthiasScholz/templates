{
  description = "A Nix-flake-based development environment for container development";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
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
            packages = with pkgs.pkgsx86_64Darwin; [
              dotnet-runtime
            ];

            # NOTE Not supported by direnv!
            # https://discourse.nixos.org/t/how-to-define-alias-in-shellhook/15299
            shellHook = ''
              dotnet --info
            '';
          };
        }
      );
    };
}
