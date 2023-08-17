#!/bin/bash -xe
set -xe

PREFIX=aarch64-linux-gnu
export CC=$PREFIX-gcc-posix
export CXX=$PREFIX-g++-posix
export CPP=$PREFIX-cpp-posix
export RANLIB=$PREFIX-ranlib
export LD=$PREFIX-ld
export AR=$PREFIX-ar
export AS=$PREFIX-as
export NM=$PREFIX-nm
export STRIP=$PREFIX-strip
export MAKEDEPPROG=$CC
export RC=$PREFIX-windres
export RESCOMP=$PREFIX-windres
export DLLTOOL=$PREFIX-dlltool
export OBJDUMP=$PREFIX-objdump
export CC_PREFIX=$PREFIX

QT_BIN=/media/isgdev/1885b256-daf3-4ea6-b95b-d4d23af9a578/repos/flp/qt-everywhere-src-5.15.10/qt5-build/qtbase/bin
export PATH="${QT_BIN}:$PATH"