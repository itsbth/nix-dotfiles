#!/usr/bin/env bash
# Update a remote host
# Usage: update-host.sh <host>

HOST="$1"
REPO_REMOTE="https://github.com/itsbth/nix-dotfiles.git"
REPO_LOCAL="~/nix-dotfiles"
BRANCH="feat/nixos"

# It will then run the following on the host:
# - Clone or update the repo
# - Run `make diff-and-switch`

ssh "$HOST" <<EOF
  set -e
  git () {
    # TODO: Skip this if git is already installed?
    nix shell nixpkgs\#git --command git "\$@"
  }
  make () {
    nix shell nixpkgs\#gnumake --command make "\$@"
  }
  if [ -d "$REPO_LOCAL" ]; then
    cd "$REPO_LOCAL"
  else
    git clone "$REPO_REMOTE" "$REPO_LOCAL"
    cd "$REPO_LOCAL"
  fi
  git checkout "$BRANCH"
  git pull
  make diff-and-switch
EOF
