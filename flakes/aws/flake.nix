{
  description = "A Nix-flake-based development environment for AWS";

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
              awscli2
              awslogs
              awslimitchecker
              aws-nuke
              # NOTE unsupported package: gossm https://github.com/gjbae1212/gossm
              # NOTE unsupproted package: sm https://github.com/clok/sm
              # build ami
              # FIXME requires unfree package support:
              # packer
              # FIXME package seems to be broken
              # ansible
              ssm-session-manager-plugin
            ];

            shellHook = ''
              function identity() { aws sts get-caller-identity }
            '';
          };
        }
      );
    };
}
