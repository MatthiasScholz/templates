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
              colima # NOTE requires docker (brew)
              docker-buildx
              docker-compose
              # NOTE Dockerfile formatting removes comments, not configurable, not maintained
              #dockfmt
              # LSP
              dockerfile-language-server-nodejs
            ];

            # NOTE Not supported by direnv!
            # https://discourse.nixos.org/t/how-to-define-alias-in-shellhook/15299
            shellHook = ''
              source <(docker completion bash)
              docker-buildx install
            '';
          };
        }
      );
    };
}
