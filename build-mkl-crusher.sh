export CXX=$(which clang++)
export CC=$(which clang)
pwd=$PWD
export HIP_PATH=$ROCM_PATH/hip
export HIP_DIR=$ROCM_PATH/hip
git clone https://github.com/oneapi-src/oneMKL.git
mkdir oneMKL/build
cd oneMKL/build
cmake .. -G Ninja \
-DREF_BLAS_ROOT=$HOME/nwchemex-sycl/lapack/build/install \
-DCMAKE_INSTALL_PREFIX=$pwd/oneMKL/install \
-DENABLE_SYCLBLAS_BACKEND=OFF \
-DENABLE_ROCBLAS_BACKEND=ON \
-DENABLE_MKLCPU_BACKEND=OFF \
-DENABLE_MKLGPU_BACKEND=OFF \
-DBUILD_SHARED_LIBS=ON \
-DHIP_TARGETS=gfx90a

#$--trace-expand \
#-DREF_LAPACK_ROOT=$HOME/nwchemex-sycl/lapack64/build/install \
#-DENABLE_ROCSOLVER_BACKEND=ON \
