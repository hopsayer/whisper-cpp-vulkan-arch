# whisper-cpp-vulkan

Сборка [whisper.cpp](https://github.com/ggerganov/whisper.cpp) с поддержкой Vulkan для Arch Linux.

## Проблема
Официальный пакет `whisper-cpp` из репозитория `extra` собран без поддержки Vulkan. Пакет `whisper-cpp-vulkan` то появлялся, то исчезал из репозитория, а сейчас его нет ни в `extra`, ни в AUR. Добавьте сюда ссылку на страницу пакета, если она есть.

## Решение
Этот репозиторий содержит PKGBUILD и готовый бинарный пакет `whisper-cpp-vulkan`, собранный с флагом `-DGGML_VULKAN=ON`.

## Установка

**Вариант 1: Из готового бинарного пакета (быстро)**
```bash
# Скачайте файл whisper-cpp-vulkan-1.9.1-1-x86_64.pkg.tar.zst из релизов
sudo pacman -U whisper-cpp-vulkan-1.9.1-1-x86_64.pkg.tar.zst
```

**Вариант 2: Собрать из исходников (надежно)**
```bash
git clone https://github.com/ВАШ_АККАУНТ/whisper-cpp-vulkan
cd whisper-cpp-vulkan
makepkg -si
```

## Важно
*   Этот пакет **конфликтует** с официальным `whisper-cpp`, поэтому при установке он его заменит.
*   Для работы Vulkan необходимы установленные драйверы и `vulkan-icd-loader`.
*   Так как [push в AUR временно отключен](https://archlinux.org/news/) из-за последствий атаки, этот репозиторий — временное решение.
