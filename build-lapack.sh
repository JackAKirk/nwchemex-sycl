git clone https://github.com/Reference-LAPACK/lapack
mkdir lapack/build; cd lapack/build
FC=gfortran CC=gcc CXX=g++ cmake -G Ninja \
-DCMAKE_INSTALL_PREFIX=$PWD/install -DCBLAS=ON \
-DBUILD_SHARED_LIBS=ON ..
ninja install
