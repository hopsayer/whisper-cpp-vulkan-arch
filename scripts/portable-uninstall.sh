#!/usr/bin/env bash
set -euo pipefail

PKG_NAME="whisper-cpp-vulkan"
XDG_SHARE="${HOME}/.local/share/${PKG_NAME}"
MANIFEST="${XDG_SHARE}/manifest.txt"

if [ ! -f "$MANIFEST" ]; then
  echo "No manifest found at $MANIFEST — nothing to uninstall (or it was installed differently)." >&2
  exit 1
fi

echo "==> Removing files listed in $MANIFEST"
while IFS= read -r f; do
  [ -e "$f" ] && rm -rf "$f" && echo "removed: $f"
done < "$MANIFEST"

rm -rf "${HOME}/.local/lib/${PKG_NAME}"
rm -rf "$XDG_SHARE"

echo ""
echo "Done. Note: the PATH entry added to your shell rc file (~/.bashrc / ~/.zshrc / ~/.profile)"
echo "was left in place since it's harmless if the directory is empty — remove it manually if you like:"
echo '  export PATH="$HOME/.local/bin:$PATH"'
