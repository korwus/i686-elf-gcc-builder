#!/usr/bin/env bash

#     i686-elf-gcc cross compiler build script
#     Copyright (C) 2017  Dani Frisk ( k4m1@protonmail.com )
# 
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
# 
#    This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
# 
#     You should have received a copy of the GNU General Public License
#     along with this program. If not, see <http://www.gnu.org/licenses/>.



set -e

# binutils and gcc version
export BINUTILS_VERSION="2.29"
export GCC_VERSION="7.2.0"

export PATH_TO_SHELL_RC="/home/$(whoami)/.zshrc"

export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

echo "Obtaining binutils and gcc..."

wget ftp://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz
wget ftp://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz

echo "Unpacking binutils and gcc..."

tar -xf binutils-$BINUTILS_VERSION.tar.gz
tar -xf gcc-$GCC_VERSION.tar.gz

echo "Obtainig gcc download prerequisities..."
cd gcc-$GCC_VERSION
./contrib/download_prerequisites
cd ../

echo "Configuring and building binutils..."
cd binutils-$BINUTILS_VERSION
mkdir -pv build
cd build
../configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install
cd ../../

echo "Configuring and building elf-i686-gcc..."
cd gcc-$GCC_VERSION
mkdir -pv build
cd build
../configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c --without-headers
make all-gcc
make all-target-libgcc
sudo make install-gcc
sudo make install-target-libgcc

echo "Cleaning up..."
cd ../../
rm -rf binutils-$BINUTILS_VERSION*
rm -rf gcc-$GCC_VERSION*

echo "Adding elf-i686-gcc to \$PATH"
echo "export PATH=\"\$HOME/opt/cross/bin:\$PATH" >> $PATH_TO_SHELL_RC

echo "Done."


