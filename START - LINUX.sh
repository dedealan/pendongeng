#!/bin/bash
# Bang Story - jalankan file ini untuk membuka aplikasi di Linux.
cd "$(dirname "$0")" || exit 1

if ! command -v node >/dev/null 2>&1; then
  echo
  echo " Node.js belum terpasang di komputer ini."
  echo " Unduh versi LTS dari https://nodejs.org, pasang, lalu jalankan file ini lagi."
  echo
  exit 1
fi

# Pertama kali dibuka, atau folder node_modules berasal dari OS lain: pasang ulang.
if [ ! -f "node_modules/.bangstory-linux" ]; then
  if [ -d "node_modules" ] && ([ -f "node_modules/.bangstory-windows" ] || [ -f "node_modules/.bangstory-mac" ]); then
    echo " Membersihkan node_modules dari sistem operasi lain..."
    rm -rf node_modules
  fi
  echo
  echo " Menyiapkan Bang Story untuk pertama kali."
  echo " Butuh koneksi internet dan beberapa menit..."
  echo
  if ! npm install; then
    echo
    echo " Gagal memasang dependensi. Periksa koneksi internet lalu coba lagi."
    exit 1
  fi
  echo ok > node_modules/.bangstory-linux
fi

# Electron mengunduh programnya sendiri saat pertama dipakai.
if [ ! -f "node_modules/electron/dist/electron" ]; then
  echo " Mengunduh Electron..."
  if ! node node_modules/electron/install.js; then
    echo
    echo " Gagal mengunduh Electron. Periksa koneksi internet lalu coba lagi."
    exit 1
  fi
fi

if [ ! -f "out/main/index.js" ]; then
  echo " Menyusun aplikasi..."
  if ! npm run build; then
    echo
    echo " Gagal menyusun aplikasi."
    exit 1
  fi
fi

nohup ./node_modules/electron/dist/electron . >/dev/null 2>&1 &
echo " Bang Story sedang dibuka."
exit 0
