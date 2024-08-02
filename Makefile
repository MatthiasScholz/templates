define flake-update
	$(eval flake=$(1))
	cd flakes/$(flake) && nix flake update
endef

upgrade:
	$(call flake-update, aws)
	$(call flake-update, go)
	$(call flake-update, opentofu)
	$(call flake-update, terraform)
	$(call flake-update, tools)
	nix flake update
