#!/bin/bash

LLVM_PATH="llvm_path=`pwd`/llvm"
JOBS=`sysctl hw.ncpu | awk '{print $2}'`

rake $LLVM_PATH clean
rake $LLVM_PATH jobs=$JOBS
sudo rake $LLVM_PATH install -q

