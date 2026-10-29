#!/bin/sh
# Install rex-theme by linking bin/rex-theme into a directory on PATH.
#
# Usage: ./install.sh [BIN_DIR]    (default: $HOME/.local/bin)
#
# A symlink, not a copy: `git pull` in this clone updates the CLI and the
# themes together, since rex-theme resolves themes/ relative to its real path.
set -eu

repo_dir=$(cd "$(dirname "$0")" && pwd -P)
bin_dir=${1:-"$HOME/.local/bin"}
target="$bin_dir/rex-theme"

if ! command -v python3 >/dev/null 2>&1; then
  echo "install.sh: python3 is required" >&2
  exit 1
fi
if ! command -v rex >/dev/null 2>&1; then
  echo "install.sh: warning: rex is not on PATH; rex-theme needs it to apply themes" >&2
fi

mkdir -p "$bin_dir"
if [ -e "$target" ] && [ ! -L "$target" ]; then
  echo "install.sh: $target exists and is not a symlink; remove it first" >&2
  exit 1
fi
chmod +x "$repo_dir/bin/rex-theme"
ln -sfn "$repo_dir/bin/rex-theme" "$target"
echo "linked $target -> $repo_dir/bin/rex-theme"

case ":$PATH:" in
  *":$bin_dir:"*) ;;
  *) echo "note: $bin_dir is not on PATH; add it to your shell profile" ;;
esac

echo "done: run 'rex-theme list'"
