.PHONEY: build diff switch diff-and-switch

HOSTNAME := $(shell hostname)

diff-and-switch: build
	$(MAKE) -o build diff
	@echo "Switch to new derivation? [y/N] " && read ans && [ $${ans:-N} = y ]
	$(MAKE) -o build switch

build:
	nix build .#darwinConfigurations.$(HOSTNAME).system

diff: build
	nix-diff /var/run/current-system ./result

switch: build
	result/sw/bin/darwin-rebuild switch --flake .#

update:
	nix flake update
