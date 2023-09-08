pwd=$PWD

cd $pwd
# build 32-bit blas (MKL wants that)
git clone https://github.com/Reference-LAPACK/lapack
cd lapack
rm -rf build; mkdir build; cd build
FC=gfortran CC=clang CXX=clang++ cmake -G Ninja \
-DCMAKE_INSTALL_PREFIX=$PWD/install -DCBLAS=ON \
-DBUILD_SHARED_LIBS=ON ..
ninja install
