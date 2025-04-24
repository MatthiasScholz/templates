{
  description = "A Nix-flake-based development environment for container development";

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
              colima
              docker-buildx
              docker-compose
              # NOTE Dockerfile formatting removes comments, not configurable, not maintained
              #dockfmt
              # LSP
              dockerfile-language-server-nodejs
              # Container testing
              goss
              # TODO darwin currently unsupport, but goss is available and dgoss is only a wrapper
              # TODO extend nixpkgs platforms to mac: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/dg/dgoss/package.nix#L42
              # dgossn
              # Prepare container build with collecting local files
              rsync
            ];

            # NOTE Not supported by direnv!
            # https://discourse.nixos.org/t/how-to-define-alias-in-shellhook/15299
            shellHook = ''
              source <(docker completion bash)
              # HACK manual install of dgoss
              curl -L https://raw.githubusercontent.com/goss-org/goss/master/extras/dgoss/dgoss -o /tmp/dgoss
              chmod +rx /tmp/dgoss
            '';
          };
        }
      );
    };
}
