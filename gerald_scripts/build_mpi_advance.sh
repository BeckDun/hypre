#!/bin/bash
set -e

pushd $1
module load gcc/8.3.1
module load cmake/3.23.1
rm -rf build
mkdir build
cd build
CC=mpicc CXX=mpicxx cmake ..
make
popd
