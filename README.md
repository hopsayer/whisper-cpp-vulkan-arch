# whisper-cpp-vulkan

A build of [whisper.cpp](https://github.com/ggerganov/whisper.cpp) with **Vulkan support** for Arch Linux.

## The Problem

The official `whisper-cpp` package from the `extra` repository is compiled **without** Vulkan acceleration. It detects dGPU, but does not use it. 
The separate `whisper-cpp-vulkan` package has appeared and disappeared from the repos multiple times, and at the moment it is **neither in `extra` nor in the AUR**.

## The Solution

This repository provides:
- A clean `PKGBUILD` that compiles `whisper.cpp` with `-DGGML_VULKAN=ON` (and `-DGGML_CUDA=OFF`) for manual building&installation with `makepkg -si`.
- A **prebuilt binary package** (`.pkg.tar.zst`) for quick installation, updated automatically along with the upstream [whisper.cpp](https://github.com/ggerganov/whisper.cpp) on a daily basis.

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

You can extract the binaries from the `.pkg.tar.zst` archive:

```bash
tar -xvf whisper-cpp-vulkan-*.pkg.tar.zst
```

The binaries will be inside `./whisper-cpp-vulkan-*/usr/bin/` (e.g., `whisper-cli`). 
Copy them wherever you like and run with `LD_LIBRARY_PATH` if needed, or install to `/usr/local`.
Or use `make install`.
Or place it as a portable installation: `~/.local/bin`, etc

## Requirements

Will be installed automatically by `makepkg -s` (for Option 2):

- **Runtime**: `vulkan-icd-loader` (and a working Vulkan driver for your GPU).
- **Build-time** (if building from source): `vulkan-headers`, `spirv-headers`, `cmake`, `ninja`, `git`.

## Important Notes
- This package **conflicts** with the official `whisper-cpp` – it will replace it upon installation.
- The included `whisper-cpp-vulkan.install` script automatically adds `whisper-cpp` to `IgnorePkg` in `/etc/pacman.conf` on install/upgrade, so a future `whisper-cpp` update in `extra` won't try to push this package out during `pacman -Syu`. It's removed from `IgnorePkg` automatically if you uninstall this package.
- Vulkan acceleration will be used automatically if a compatible GPU and drivers are present. If not, the CPU fallback will engage.
- Since official Arch repos provide users with the CPU-only `whisper-cpp` build and `-vulkan`/`-cuda` packages are constantly moved, removed and renamed, it's much easier just to install via this modified PKGBUILD.

---

*If you encounter any issues, please open an issue on GitHub.*

