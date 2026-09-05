> [!WARNING]
> **This package is conceptually obsolete as of July 1, 2026.**
>
> **What to do now:** `pacman -S whisper-cpp ggml-vulkan`
>
> The official `extra/whisper-cpp` package now uses a modular ggml backend
> system — the same binary works with any backend installed alongside it.
> No separate Vulkan build is needed anymore.
>
> **This package also conflicts with `ggml`, `ggml-vulkan`, and `llama-cpp`.**
> Installing it will remove those packages. If you use `llama-cpp` or anything
> else from the ggml ecosystem, do NOT install this — use the official solution above.

# whisper-cpp-vulkan

A self-contained build of [whisper.cpp](https://github.com/ggerganov/whisper.cpp) with bundled Vulkan support for Arch Linux. Kept as a historical reference.

## Why this exists

In July–August 2026, enabling GPU acceleration for `whisper-cpp` on Arch via Vulkan was a genuinely unsolvable puzzle:

- The official `extra/whisper-cpp` detected your GPU but didn't use it.
- Googling the problem led only to outdated information — or back to this repo and [my related post](https://www.reddit.com/r/archlinux/comments/1vn5k3e/solution_whispercpp_with_vulkan_support_for_arch/). Me as a user literally became trapped within a vicious cycle of outdated sources.
- `ggml-vulkan` — the package that actually fixes it — existed since June 19, but nothing pointed to it: pacman didn't mention it, there was no Arch Wiki page for whisper-cpp (unlike [llama-cpp](https://wiki.archlinux.org/title/Llama.cpp), where ggml-backends are explicitly listed and mentioned to be installed), and no search results connected the two. 
- So there was a several months time window during which it was hard to figure out how to make whisper-cpp just use the damn GPU. 

The fix (`pacman -S whisper-cpp ggml-vulkan`) became discoverable only by accident: a Reddit commenter mentioned `ggml` (not even `ggml-vulkan`), which by chance led to the llama.cpp Arch Wiki page, which listed the ggml backends and implied `ggml` is a split package — some logic became visible.

On July 1, 2026, `whisper-cpp` 1.9.1-1 landed in `extra` with `WHISPER_USE_SYSTEM_GGML=ON` and `replaces=(whisper-cpp-vulkan)`, making this package redundant. It took until September 3 to find out.

The underlying discoverability problem — that `whisper-cpp` doesn't list `ggml-vulkan` as an `optdepends` — remains open. A bug report / MR to the official package is planned.

## Installation

### Option 1: Install the prebuilt binary (fast)

Download and install the latest release:

```bash
curl -L https://github.com/hopsayer/whisper-cpp-vulkan-arch/releases/latest/download/whisper-cpp-vulkan-x86_64.pkg.tar.zst -o whisper-cpp-vulkan.pkg.tar.zst
sudo pacman -U whisper-cpp-vulkan.pkg.tar.zst
```

### Option 2: Build from source (transparent)

```bash
git clone https://github.com/hopsayer/whisper-cpp-vulkan-arch
cd whisper-cpp-vulkan-arch
makepkg -si
```

### Option 3: Not an Arch system

**Automatic portable installation script** 

(no root, no package manager — installs under your user's `~/.local/{bin,lib,share}` and adds `~/.local/bin` to `PATH` if missing):

```bash
curl -fsSL https://raw.githubusercontent.com/hopsayer/whisper-cpp-vulkan-arch/main/scripts/portable-install.sh | bash
```

To remove everything installed this way:

```bash
curl -fsSL https://raw.githubusercontent.com/hopsayer/whisper-cpp-vulkan-arch/main/scripts/portable-uninstall.sh | bash
```

<details>
<summary>What the portable install script does (folder layout)</summary>

```
~/.local/lib/whisper-cpp-vulkan/         ← all .so files
~/.local/lib/whisper-cpp-vulkan/bin/*    ← the real binaries (whisper-cli, etc.)
~/.local/bin/whisper-cli                 ← a thin wrapper script that sets LD_LIBRARY_PATH and execs the real binary above
~/.local/share/whisper-cpp-vulkan/manifest.txt  ← list of every installed file, used by the uninstall script
```

</details>

**Manually unpack the release archive into any folder**

```bash
tar -xvf whisper-cpp-vulkan-*.pkg.tar.zst
```

The binaries will be inside `./usr/bin/` (e.g., `whisper-cli`), libraries inside `./usr/lib/`.
Copy them wherever you like and run with `LD_LIBRARY_PATH` if needed, or install to `/usr/local`, or place as a portable install under `~/.local/bin` + `~/.local/lib`, etc.

## Requirements

Will be installed automatically by `makepkg -s` (for Option 2):

- **Runtime**: `vulkan-icd-loader` (and a working Vulkan driver for your GPU).
- **Build-time** (if building from source): `vulkan-headers`, `spirv-headers`, `cmake`, `ninja`, `git`.

## Important Notes (limited relevance now)
- This package **conflicts** with the official `whisper-cpp` – it will replace it upon installation.
- The included `whisper-cpp-vulkan.install` script automatically adds `whisper-cpp` to `IgnorePkg` in `/etc/pacman.conf` on install/upgrade, so a future `whisper-cpp` update in `extra` won't try to push this package out during `pacman -Syu`. It's removed from `IgnorePkg` automatically if you uninstall this package.
- Vulkan acceleration will be used automatically if a compatible GPU and drivers are present. If not, the CPU fallback will engage.
- Since official Arch repos provide users with the CPU-only `whisper-cpp` build and `-vulkan`/`-cuda` packages are constantly moved, removed and renamed, it's much easier just to install via this modified PKGBUILD.

---

*If you encounter any issues, please open an issue on GitHub.*

