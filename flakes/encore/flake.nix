{
  description = "Encore development environment";

  inputs = {
     nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
     encorePkg.url = "path:./package";
  };

  outputs = { self, nixpkgs, encorePkg }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            # FIXME not working - check diff encore
          ];
        };
      });
    };
}
