# `whisper-cpp` package in pacman's `extra` repo:
# Maintainer: Maxime Gauduin <alucryd@archlinux.org>
# Contributor: Wuxxin <wuxxin@gmail.com>

pkgname=whisper-cpp-vulkan
pkgver=1.9.1
pkgrel=2
options=(!debug)
pkgdesc="Port of OpenAI's Whisper model in C/C++"
arch=(x86_64)
url=https://github.com/ggerganov/whisper.cpp
license=(MIT)
install=whisper-cpp-vulkan.install
depends=(
  ffmpeg
  glibc
  libgcc
  libstdc++
  vulkan-icd-loader
  ggml-vulkan
)
conflicts=(whisper-cpp)
provides=(whisper-cpp)
replaces=(
  whisper-cpp-rocm
  whisper-cpp-vulkan
)
makedepends=(
  cmake
  git
  ninja
  spirv-headers
  vulkan-headers
  ggml-vulkan
)
source=(git+https://github.com/ggml-org/whisper.cpp.git#tag=v${pkgver})
b2sums=('SKIP')

build() {
  cmake -S whisper.cpp -B build -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DWHISPER_COMMON_FFMPEG=ON \
      -DWHISPER_BUILD_EXAMPLES=ON \
      -DWHISPER_BUILD_SERVER=ON \
      -DWHISPER_BUILD_TESTS=OFF \
      -DGGML_VULKAN=ON \
      -DGGML_CUDA=OFF \
      -DWHISPER_USE_SYSTEM_GGML=ON
  cmake --build build
}

package() {
  DESTDIR="${pkgdir}" cmake --install build
  install -Dm 644 whisper.cpp/LICENSE -t "${pkgdir}"/usr/share/licenses/${pkgname}
}


