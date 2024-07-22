update:
	cd flakes/go && nix flake update
	cd flakes/terraform && nix flake update
	nix flake update
