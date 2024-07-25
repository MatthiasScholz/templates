update:
	cd flakes/go && nix flake update
	cd flakes/terraform && nix flake update
	cd flakes/tools && nix flake update
	cd flakes/aws && nix flake update
	nix flake update
