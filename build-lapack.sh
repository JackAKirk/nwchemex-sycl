git clone https://github.com/Reference-LAPACK/lapack
mkdir lapack/build; cd lapack/build
cmake -DCMAKE_INSTALL_PREFIX=$PWD -DCBLAS=ON -DBUILD_SHARED_LIBS=ON ..
make -j
