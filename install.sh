#!/bin/sh
set -eu

cmake -B build -S . -DINSTALL_PLASMOID=ON -DCMAKE_INSTALL_PREFIX="$HOME/.local"
cmake --build build
cmake --install build

echo "Installed btop widget. Add it from the Plasma widget chooser."
