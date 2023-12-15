{
  description = "Encore is the Development Platform that automatically provisions type-safe infrastructure, from developing locally to scaling production in your cloud on AWS/GCP.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = {self, nixpkgs}: {
    defaultPackage.x86_64-darwin =
      with import nixpkgs { system = "x86_64-darwin"; };

      stdenv.mkDerivation rec {
        name = "encore-${version}";
        version = "1.29.5";

        src = pkgs.fetchurl {
          url = "https://d2f391esomvqpi.cloudfront.net/${name}-darwin_amd64.tar.gz";
          sha256 = "sha256-6v/hIBE0yz5CA+ROb6Fsm2u46Uzqr4knrXWiON0QwBc=";
        };

        sourceRoot = ".";

        installPhase = ''
          mkdir -p $out
          cp -pR bin/. $out/bin
          cp -pR encore-go/. $out/encore-go
          cp -pR runtimes/. $out/runtimes
        '';

        doInstallCheck = true;
        installCheckPhase = ''
          $out/bin/encore version
        '';

        meta = with lib; {
          homepage = "https://encore.dev/";
          description = "Encore is the Development Platform that automatically provisions type-safe infrastructure, from developing locally to scaling production in your cloud on AWS/GCP.";
          platforms = [ "x86_64-darwin" ];
        };
      };
  };
}
