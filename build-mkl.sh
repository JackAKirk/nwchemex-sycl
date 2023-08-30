export CXX=$(which clang++)
export CC=$(which clang)
export LIBRARY_PATH=/opt/rocm-4.5.2/llvm/lib/clang/13.0.0/lib/linux/:$LIBRARY_PATH
export HIP_PATH=/opt/rocm-4.5.2/hip
git clone https://github.com/oneapi-src/oneMKL.git
rm -rf oneMKL/build; mkdir oneMKL/build
cd oneMKL/build
cmake .. \
-DCMAKE_INSTALL_PREFIX=$HOME/oneMKL/install \
-DENABLE_SYCLBLAS_BACKEND=OFF \
-DENABLE_ROCBLAS_BACKEND=ON \
-DENABLE_MKLCPU_BACKEND=OFF \
-DENABLE_MKLGPU_BACKEND=OFF \
-DTARGET_DOMAINS=blas \
-DBUILD_SHARED_LIBS=ON \
-DCMAKE_CXX_COMPILER=$CXX \
-DCMAKE_C_COMPILER=$CC \
-DREF_BLAS_ROOT=$HOME/lapack/build \
-DHIP_TARGETS=gfx1030
make -j 16 install

