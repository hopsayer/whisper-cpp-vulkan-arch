#!/usr/bin/env bash
set -euo pipefail

# whisper-cpp-vulkan portable installer
# Extracts the prebuilt .pkg.tar.zst and installs it under the user's
# XDG directories (~/.local/bin, ~/.local/lib, ~/.local/share), without
# touching the system package manager.

REPO="hopsayer/whisper-cpp-vulkan-arch"
PKG_NAME="whisper-cpp-vulkan"

XDG_BIN="${HOME}/.local/bin"
XDG_LIB="${HOME}/.local/lib/${PKG_NAME}"
XDG_SHARE="${HOME}/.local/share/${PKG_NAME}"
MANIFEST="${XDG_SHARE}/manifest.txt"

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "==> Fetching latest release info..."
ASSET_URL=$(curl -s "https://api.github.com/repos/${REPO}/releases/latest" \
  | grep -Eo '"browser_download_url": *"[^"]*'"${PKG_NAME}"'-[0-9][^"]*x86_64\.pkg\.tar\.zst"' \
  | grep -v -- '-debug-' \
  | head -n1 \
  | sed -E 's/.*"(https[^"]+)"/\1/')

if [ -z "$ASSET_URL" ]; then
  echo "ERROR: could not resolve download URL from the latest GitHub release." >&2
  exit 1
fi

echo "==> Downloading: $ASSET_URL"
curl -L "$ASSET_URL" -o "${TMPDIR}/pkg.pkg.tar.zst"

echo "==> Extracting..."
mkdir -p "${TMPDIR}/extracted"
tar -xf "${TMPDIR}/pkg.pkg.tar.zst" -C "${TMPDIR}/extracted"

if [ ! -d "${TMPDIR}/extracted/usr/bin" ]; then
  echo "ERROR: unexpected package layout, usr/bin not found." >&2
  exit 1
fi

mkdir -p "$XDG_BIN" "$XDG_LIB/bin" "$XDG_SHARE"
: > "$MANIFEST"

echo "==> Installing libraries to $XDG_LIB"
if [ -d "${TMPDIR}/extracted/usr/lib" ]; then
  cp -a "${TMPDIR}/extracted/usr/lib/." "$XDG_LIB/"
  find "$XDG_LIB" -maxdepth 1 -mindepth 1 ! -name bin | while read -r f; do
    echo "$f" >> "$MANIFEST"
  done
fi

echo "==> Installing binaries to $XDG_LIB/bin (real binaries) + $XDG_BIN (wrappers)"
for bin in "${TMPDIR}/extracted/usr/bin/"*; do
  name="$(basename "$bin")"
  cp -a "$bin" "${XDG_LIB}/bin/${name}"
  echo "${XDG_LIB}/bin/${name}" >> "$MANIFEST"

  wrapper="${XDG_BIN}/${name}"
  cat > "$wrapper" <<WRAP
#!/usr/bin/env bash
export LD_LIBRARY_PATH="${XDG_LIB}:\${LD_LIBRARY_PATH:-}"
exec "${XDG_LIB}/bin/${name}" "\$@"
WRAP
  chmod +x "$wrapper"
  echo "$wrapper" >> "$MANIFEST"
done

echo "==> Checking PATH for $XDG_BIN"
if [[ ":$PATH:" != *":${XDG_BIN}:"* ]]; then
  RC_FILE=""
  case "$(basename "${SHELL:-bash}")" in
    zsh)  RC_FILE="${HOME}/.zshrc" ;;
    bash) RC_FILE="${HOME}/.bashrc" ;;
    *)    RC_FILE="${HOME}/.profile" ;;
  esac
  {
    echo ""
    echo "# Added by whisper-cpp-vulkan portable installer"
    echo "export PATH=\"\$HOME/.local/bin:\$PATH\""
  } >> "$RC_FILE"
  echo "==> Added \$HOME/.local/bin to PATH in $RC_FILE (restart your shell or 'source $RC_FILE')"
else
  echo "==> $XDG_BIN is already in PATH"
fi

echo ""
echo "Done. Installed: $(ls "${TMPDIR}/extracted/usr/bin" | tr '\n' ' ')"
echo "Manifest written to: $MANIFEST"
echo "Run 'whisper-cli --help' after restarting your shell (or sourcing your rc file)."
