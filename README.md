# whisper-cpp-vulkan

A build of [whisper.cpp](https://github.com/ggerganov/whisper.cpp) with **Vulkan support** for Arch Linux.

## The Problem

The official `whisper-cpp` package from the `extra` repository is compiled **without** Vulkan acceleration.  
The separate `whisper-cpp-vulkan` package has appeared and disappeared from the repos multiple times, and at the moment it is **neither in `extra` nor in the AUR**.

## The Solution

This repository provides:
- A clean `PKGBUILD` that compiles `whisper.cpp` with `-DGGML_VULKAN=ON` (and `-DGGML_CUDA=OFF`).
- A **prebuilt binary package** (`.pkg.tar.zst`) for quick installation.

## Installation

### Option 1: Install the prebuilt binary (fast)
```bash
# Download the .pkg.tar.zst file from the Releases section of this repo
sudo pacman -U whisper-cpp-vulkan-1.9.1-1-x86_64.pkg.tar.zst
```

### Option 2: Build from source (transparent)
```bash
git clone https://github.com/hopsayer/whisper-cpp-vulkan
cd whisper-cpp-vulkan
makepkg -si
```

## Requirements

- **Runtime**: `vulkan-icd-loader` (and a working Vulkan driver for your GPU).
- **Build-time** (if building from source): `vulkan-headers`, `spirv-headers`, `cmake`, `ninja`, `git`.  
  `makepkg -s` will install these automatically.

## Important Notes

- This package **conflicts** with the official `whisper-cpp` – it will replace it upon installation.
- Vulkan acceleration will be used automatically if a compatible GPU and drivers are present.
- Since AUR pushes are temporarily disabled ([[1](https://lists.archlinux.org/archives/list/aur-general@lists.archlinux.org/message/YPJ3FQYJTJXXY3RUXCYLMHUKHLIUNVFF/)], [[2](https://archlinux.org/news/active-aur-malicious-packages-incident/)]) due to the recent supply‑chain attack, this repository serves as a **temporary solution** until normal AUR operations resume.
