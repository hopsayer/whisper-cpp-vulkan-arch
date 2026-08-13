# whisper-cpp-vulkan

A build of [whisper.cpp](https://github.com/ggerganov/whisper.cpp) with **Vulkan support** for Arch Linux.

## The Problem

The official `whisper-cpp` package from the `extra` repository is compiled **without** Vulkan acceleration. It detects dGPU, but does not use it. 
The separate `whisper-cpp-vulkan` package has appeared and disappeared from the repos multiple times, and at the moment it is **neither in `extra` nor in the AUR**.

## The Solution

This repository provides:
- A clean `PKGBUILD` that compiles `whisper.cpp` with `-DGGML_VULKAN=ON` (and `-DGGML_CUDA=OFF`).
- A **prebuilt binary package** (`.pkg.tar.zst`) for quick installation.

## Installation

### Option 1: Install the prebuilt binary (fast)

Download and install the latest release:

```bash
curl -L https://github.com/hopsayer/whisper-cpp-vulkan-arch/releases/latest/download/whisper-cpp-vulkan-*.pkg.tar.zst -o whisper-cpp-vulkan.pkg.tar.zst
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

## Requirements

Will be installed automatically by `makepkg -s` (for Option 2):

- **Runtime**: `vulkan-icd-loader` (and a working Vulkan driver for your GPU).
- **Build-time** (if building from source): `vulkan-headers`, `spirv-headers`, `cmake`, `ninja`, `git`.

## Important Notes

- This package **conflicts** with the official `whisper-cpp` – it will replace it upon installation.
- Vulkan acceleration will be used automatically if a compatible GPU and drivers are present. If not, the CPU fallback will engage.
- Since **AUR pushes are temporarily disabled** ([[1]](https://lists.archlinux.org/archives/list/aur-general@lists.archlinux.org/message/YPJ3FQYJTJXXY3RUXCYLMHUKHLIUNVFF/), [[2]](https://archlinux.org/news/active-aur-malicious-packages-incident/)) due to the recent supply‑chain attack, this repository serves as a **temporary solution** until normal AUR operations resume.

---

*If you encounter any issues, please open an issue on GitHub.*
```

