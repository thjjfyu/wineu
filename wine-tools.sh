#!/bin/bash

current_dir_name="${PWD##*/}"
if [ "$current_dir_name" != "build" ]; then
    echo "This script must be run from the 'build' directory inside your Wine source tree."
    echo "Please 'cd build' and run again."
    exit 1
fi

echo "Starting native wine-tools build in place..."

# Clean any previous build artifacts
rm -rf wine-tools-build

# Create a fresh build directory for wine-tools
mkdir wine-tools-build
cd wine-tools-build

# Run configure with your options, pointing back to the wine source root (..)
../configure --without-x --without-gstreamer --without-vulkan --without-wayland

echo "Configuring done. Starting build of native wine-tools..."

# Build native wine-tools directly in place
# Build all tools one by one

make -C tools/winebuild -j$(nproc)
make -C wrc -j$(nproc)
make -C widl -j$(nproc)
make -C winegcc -j$(nproc)
make -C sfnt2fon -j$(nproc)
make -C winedump -j$(nproc)
make -C winemaker -j$(nproc)
make -C wmc -j$(nproc)

# Compile make_xftmpl.c explicitly (as in your original script)
gcc ../tools/make_xftmpl.c -I../wine-tools-build/include -I../include -o ../tools/make_xftmpl

# Copy and chmod wineapploader
cp ../tools/wineapploader.in ../tools/wineapploader
chmod +x ../tools/wineapploader

echo "Native wine-tools build complete."

cd ..

echo "Build environment ready. You can now proceed with the rest of your Wine build."
