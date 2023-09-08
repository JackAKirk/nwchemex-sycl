export CXX=$(which clang++)
export CC=$(which clang)
mydir=$PWD
git clone https://github.com/oneapi-src/oneMKL.git
rm -rf oneMKL/build; mkdir oneMKL/build
cd oneMKL/build
cmake .. -G Ninja \
-DCMAKE_INSTALL_PREFIX=$mydir/oneMKL/install \
-DENABLE_SYCLBLAS_BACKEND=OFF \
-DENABLE_CUBLASS_BACKEND=ON \
-DENABLE_MKLCPU_BACKEND=OFF \
-DENABLE_MKLGPU_BACKEND=OFF \
-DTARGET_DOMAINS=blas \
-DBUILD_SHARED_LIBS=ON \
-DCMAKE_CXX_COMPILER=$CXX \
-DCMAKE_C_COMPILER=$CC \
-DREF_BLAS_ROOT=$mydir/lapack/build/install 

