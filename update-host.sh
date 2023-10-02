#!/usr/bin/env bash
# Update a remote host
# Usage: update-host.sh [-r <remote-repo>] [-l <local-repo>] [-b <branch>] <user@host>

set -e

usage() {
  echo "Usage: update-host.sh [-r <remote-repo>] [-l <local-repo>] [-b <branch>] <user@host>"
}

# Default values for optional variables
REPO_REMOTE="https://github.com/itsbth/nix-dotfiles.git"
REPO_LOCAL="./nix-dotfiles"
BRANCH="$(git rev-parse --abbrev-ref HEAD)" # TODO: Require flag for non-main branch?

# Get options
while getopts ":r:l:b:h" opt; do
  case $opt in
    r) REPO_REMOTE="$OPTARG" ;;
    l) REPO_LOCAL="$OPTARG" ;;
    b) BRANCH="$OPTARG" ;;
    h) usage; exit 0 ;;
    \?) echo "Invalid option: -$OPTARG" >&2; usage; exit 1 ;;
    :) echo "Option -$OPTARG requires an argument" >&2; usage; exit 1 ;;
  esac
done

shift $((OPTIND - 1))

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

REMOTE="$1"

SCRIPT_FILE="$(mktemp)"
trap 'rm -f "$SCRIPT_FILE"' EXIT

cat > "$SCRIPT_FILE" <<EOF
set -e
if [ -d "$REPO_LOCAL" ]; then
  cd "$REPO_LOCAL"
  git pull
else
  git clone "$REPO_REMOTE" "$REPO_LOCAL"
  cd "$REPO_LOCAL"
fi
git checkout "$BRANCH"
sudo nix shell nixpkgs#git nixpkgs#gnumake nixpkgs#nix-diff --command make diff-and-switch
EOF

# Copy the script to the remote host
scp "$SCRIPT_FILE" "$REMOTE:/tmp/update-host.sh"

# Run the script on the remote host
ssh -t "$REMOTE" "bash /tmp/update-host.sh"

# Remove the script from the remote host and the local machine
ssh "$REMOTE" "rm /tmp/update-host.sh"
rm "$SCRIPT_FILE"
