#!/bin/bash

JOBS=`sysctl hw.ncpu | awk '{print $2}'`

curl http://llvm.org/releases/2.9/llvm-2.9.tgz --output "llvm-2.9.tgz"
tar xzf llvm-2.9.tgz

cd llvm-2.9
./configure --prefix `pwd`/../llvm --enable-optimized
make -j$JOBS
make install

# Cleanup
# rm llvm-2.9.tgz
# rm -rf llvm-2.9

cd ..
./tool/compile.command

