#!/bin/bash
# Copyright (C) 2015-2016 UBERTC
# This file is free software; UBER TOOLCHAINS
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.

# Colorize build warnings, errors, and scripted prints
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
red=$(tput setaf 1) # red
grn=$(tput setaf 2) # green
blu=$(tput setaf 4) # blue
txtbld=$(tput bold) # Bold
bldred=${txtbld}$(tput setaf 1) # red
bldgrn=${txtbld}$(tput setaf 2) # green
bldblu=${txtbld}$(tput setaf 4) # blue
txtrst=$(tput sgr0) # Reset

echo ""
echo "${bldblu}Your system is preparing to build ....    ${txtrst}"
echo "${bldblu}                                          ${txtrst}"
echo "${bldblu} ________________________________________ ${txtrst}"
echo "${bldblu}|                                        |${txtrst}"
echo "${bldblu}| _|    _|  _|_|_|    _|_|_|_|  _|_|_|   |${txtrst}"
echo "${bldblu}| _|    _|  _|    _|  _|        _|    _| |${txtrst}"
echo "${bldblu}| _|    _|  _|_|_|    _|_|_|    _|_|_|   |${txtrst}"
echo "${bldblu}| _|    _|  _|    _|  _|        _|    _| |${txtrst}"
echo "${bldblu}| _|    _|  _|    _|  _|        _|    _| |${txtrst}"
echo "${bldblu}|   _|_|    _|_|_|    _|_|_|_|  _|    _| |${txtrst}"
echo "${bldblu}|                                        |${txtrst}"
echo "${bldblu}|           LINARO TOOLCHAINS            |${txtrst}"
echo "${bldblu}|________________________________________|${txtrst}"
echo "${bldblu}                                          ${txtrst}"

# Try to parallelize the build for faster performance.
export NUM_JOBS="$(cat /proc/cpuinfo | grep -c processor)";
MAKE_FLAGS=-j"$NUM_JOBS";

#Export Toolchain Root Directory
export DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd );

# Autoclean Build Folder and Final Toolchain Destination
echo ""
echo "${bldblu}Cleaning up files from previous compile!${txtrst}"
echo ""
cd build;
if [ -e Makefile ];
then
    make $MAKE_FLAGS clean &> /dev/null;
    make $MAKE_FLAGS distclean &> /dev/null;
fi;
export UBER_PATH=$DIR/out/x86_64-linux-android-5.x;
export PREFIX=--prefix=$UBER_PATH;
if [ -d "$UBER_PATH" ];
then
    rm -rf $UBER_PATH;
    mkdir -p $UBER_PATH;
else
    mkdir -p $UBER_PATH;
fi;

# UBERROOT
export UBERROOT_SRC_PATH=../sysroot/arch-x86_64;
export UBERROOT_DEST_PATH=$UBER_PATH;
cp -R $UBERROOT_SRC_PATH -f $UBERROOT_DEST_PATH;
export UBERROOT=--with-sysroot=$UBERROOT_DEST_PATH/arch-x86_64;

# Build Configuration
./configure $PREFIX $UBERROOT --host=x86_64-linux-gnu --build=x86_64-linux-gnu --target=x86_64-linux-android --program-transform-name='s&^&x86_64-linux-android-&' --with-gcc-version=UBER --with-pkgversion='UBERTC-5.x.x' --with-binutils-version=uber --with-gold-version=uber --with-gmp-version=uber --with-mpfr-version=uber --with-mpc-version=uber --with-cloog-version=uber --with-isl-version=uber --with-host-libstdcxx='-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm' --with-gxx-include-dir=$UBERROOT_DEST_PATH/c++ --enable-initfini-array --enable-gnu-indirect-function --enable-gold=default --enable-threads --enable-multilib=m32,m64,mx32 --with-libexpat --with-python --with-gnu-ld --with-gnu-as --disable-werror --disable-shared --disable-option-checking --disable-bootstrap --disable-libsanitizer --quiet --enable-plugins --with-bugurl=sayeed.afridi2009@gmail.com;


# Build the toolchain
echo ""
echo "${bldblu}Building your UBER LINARO x86_64-linux-5.x Toolchain!!!${txtrst}"
echo ""
all1=$(date +%s.%N)
script -q $DIR/out/UBER-LINARO-x86_64-linux-android-5.x.log -c "make 1>/dev/null $MAKE_FLAGS";

# Install the toolchain - two times just in case
echo ""
echo "${bldblu}Installing Toolchain to:${txtrst}${blu} $UBER_PATH ${txtrst}"
echo ""
make install &> /dev/null && make install &> /dev/null;

# Did we successfully make the toolchain?
GCC_INSTALLED=$UBER_PATH/bin/x86_64-linux-android-gcc;
if [ -e $GCC_INSTALLED ];
then
    echo "${bldgrn} ${txtrst}"
    echo "${bldgrn}      _/_/_/                                                            ${txtrst}"
    echo "${bldgrn}   _/        _/    _/    _/_/_/    _/_/_/    _/_/      _/_/_/    _/_/_/ ${txtrst}"
    echo "${bldgrn}    _/_/    _/    _/  _/        _/        _/_/_/_/  _/_/      _/_/     ${txtrst}"
    echo "${bldgrn}       _/  _/    _/  _/        _/        _/            _/_/      _/_/  ${txtrst}"
    echo "${bldgrn}_/_/_/      _/_/_/    _/_/_/    _/_/_/    _/_/_/  _/_/_/    _/_/_/      ${txtrst}"
    echo "${bldgrn} ${txtrst}"
    echo "${bldgrn}Your UBER-LINARO 5.x.x x86_64 Toolchain has completed successfully!!! ${txtrst}"
    echo "${bldgrn}Toolchain is located at:${txtrst}${grn} $UBER_PATH ${txtrst}"
    echo "${bldgrn} ${txtrst}"
    all2=$(date +%s.%N)
    echo "${bldgrn}Total elapsed time: ${txtrst}${grn}$(echo "($all2 - $all1) / 60"|bc ) minutes ($(echo "$all2 - $all1"|bc ) seconds) ${txtrst}"
    sleep 5
else
    echo " "
    echo "${bldred}**************ERROR***************** ${txtrst}"
    echo "${bldred}**************ERROR***************** ${txtrst}"
    echo "${bldred}**************ERROR***************** ${txtrst}"
    echo "${bldred}     Sorry your build failed         ${txtrst}"
    echo "${bldred}**************ERROR***************** ${txtrst}"
    echo "${bldred}**************ERROR***************** ${txtrst}"
    echo "${bldred}**************ERROR***************** ${txtrst}"
    echo " "
    echo "${bldred}Error Log is found at:${txtrst}${red} $DIR/out/UBER-LINARO-ANDROIDEABI-5.x.log ${txtrst}"
    echo " "
    read -p "Press ENTER to Exit"
fi;
