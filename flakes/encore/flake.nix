{
  description = "Encore development environment";

  inputs = {
     nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
     encorePkg.url = "path:./package";
     flake-utils.url = "github:numtide/flake-utils";
  };

                             # V Add this one. Order matters.
  outputs = { self, nixpkgs, encorePkg, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-darwin" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        encore = encorePkg.defaultPackage.${system}; # For convenience
      in {
        devShell = pkgs.mkShell rec {
          buildInputs = [
            encore
          ];
        };
      });
}
