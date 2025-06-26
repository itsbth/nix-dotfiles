# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Nix-based dotfiles repository managing system configurations for both Darwin (macOS) and NixOS hosts. It uses Nix flakes with nix-darwin for macOS configurations and standard NixOS configurations for Linux hosts.

## Architecture

- **`flake.nix`**: Main entry point defining system configurations
  - `darwinConfigurations`: macOS configurations for different hosts
  - `nixosConfigurations`: NixOS configurations
- **`hosts/`**: Host-specific configurations
  - `itsbth-mbp13/`: MacBook Pro configuration
  - `nixos/`: Generic NixOS configuration
- **`modules/`**: Reusable configuration modules
  - `home.nix`: Home Manager configuration for user-level packages and settings
  - `overlays.nix`: Package overlays
  - `yabai.nix`: Window manager configuration for macOS
  - `hyprland.nix`: Wayland compositor for Linux
  - `k3s.nix`: Kubernetes cluster configuration
- **`packages/`**: Custom package definitions
- **`config/`**: Configuration files for various applications

## Common Commands

### Build and Switch System
```bash
# Build the system configuration
make build

# Show differences between current and new configuration
make diff

# Interactive build and switch with confirmation
make diff-and-switch

# Switch to built configuration
make switch
```

### Maintenance
```bash
# Update flake inputs
make update
nix flake update

# Garbage collection (system and home)
make collect-garbage

# System-only garbage collection
make collect-garbage-system

# Home-only garbage collection  
make collect-garbage-home
```

### Remote Host Management
```bash
# Update a remote host
./update-host.sh user@hostname

# With custom options
./update-host.sh -r <repo-url> -l <local-path> -b <branch> user@hostname
```

### Formatting
```bash
# Format Nix files
nixfmt-rfc-style **/*.nix
```

## Host Configuration

The system automatically detects the hostname and builds the appropriate configuration:
- **Darwin**: Uses `darwinConfigurations.<hostname>.system`
- **NixOS**: Uses `nixosConfigurations.<hostname>.config.system.build.toplevel`

## Key Features

- **Cross-platform**: Supports both macOS (nix-darwin) and NixOS
- **Home Manager integration**: User-level configuration management
- **Development environment**: Includes Neovim, development tools, and language servers
- **Window management**: Yabai for macOS, Hyprland for Linux
- **Container support**: Docker, Podman, Lima configurations
- **Git configuration**: Comprehensive Git setup with conditional includes
- **Shell environment**: Zsh with plugins, Starship prompt, and command-line tools

## Development Workflow

1. Make changes to configuration files in `modules/` or `hosts/`
2. Test with `make build` to verify syntax
3. Review changes with `make diff`
4. Apply with `make switch` or use `make diff-and-switch` for interactive workflow
5. For remote hosts, use `./update-host.sh` script

## Package Management

- System packages: Add to `environment.systemPackages` in host configurations
- User packages: Add to `home.packages` in `modules/home.nix`
- Custom packages: Define in `packages/` directory
- Unfree packages: Add to `allowUnfreePredicate` in host configuration