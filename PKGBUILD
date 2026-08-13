# Maintainer: Maxime Gauduin <alucryd@archlinux.org>
# Contributor: Wuxxin <wuxxin@gmail.com>

pkgname=whisper-cpp-vulkan
pkgver=1.9.1
pkgrel=2
pkgdesc="Port of OpenAI's Whisper model in C/C++"
arch=(x86_64)
url=https://github.com/ggerganov/whisper.cpp
license=(MIT)
depends=(
  ffmpeg
  glibc
  libgcc
  libstdc++
  vulkan-icd-loader
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
)
source=(git+https://github.com/ggml-org/whisper.cpp.git#tag=v${pkgver})
b2sums=('ec3a6e2a60485e0eb78fbec2ea133f821a180542fbac98e3e63098436cf3a6b012c35e3e660dd2ec016dcd8fc033937a17092757f5d625c6bd83817d9c27a40b')

build() {
  cmake -S whisper.cpp -B build -G Ninja \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DWHISPER_COMMON_FFMPEG=ON \
      -DWHISPER_BUILD_EXAMPLES=ON \
      -DWHISPER_BUILD_SERVER=ON \
      -DWHISPER_BUILD_TESTS=OFF \
      -DGGML_VULKAN=ON \
      -DGGML_CUDA=OFF
  cmake --build build
}

package() {
  DESTDIR="${pkgdir}" cmake --install build
  install -Dm 644 whisper.cpp/LICENSE -t "${pkgdir}"/usr/share/licenses/${pkgname}
}
