
export MKLROOT=$HOME/nwchemex-sycl/oneMKL
export CXX=$(which clang++)
export CC=$(which clang)
export HIP_PATH=$ROCM_PATH/hip

export CRAYPE_LINK_TYPE=dynamic

#ROCM_PATH=$SYCL_BUILD_PI_HIP_ROCM_DIR
declare rocm_version="${ROCM_PATH}"
prefix="/opt/rocm-"
rocm_version=${rocm_version#"$prefix"}
echo $rocm_version

NOW=$(date +"%m-%d-%Y")

export PROJECT_DIR=$PWD/Exachem_sycl_rocm
echo $PROJECT_DIR

echo $ROCM_PATH
declare rocm_version="${ROCM_PATH}"
declare rocm_version=${rocm_version#"/opt/rocm-"}
echo $rocm_version

export CMAKE_OPTIONS="-DCMAKE_INSTALL_PREFIX=$PROJECT_DIR/install_sycl_rocm -DUSE_OPENMP=OFF -DUSE_DPCPP=ON -DROCM_ROOT=${ROCM_PATH} -DGCCROOT=/opt/cray/pe/gcc/12.2.0/snos \
-DBUILD_LIBINT=ON \
-DHDF5_ROOT=$HDF5_ROOT \
	-DCMAKE_BUILD_TYPE=Release"
echo $CMAKE_OPTIONS
#-DBUILD_TESTS=OFF \

#-DLINALG_VENDOR=IntelMKL -DLINALG_PREFIX=$MKLROOT/install \

mkdir -p $PROJECT_DIR
cd $PROJECT_DIR

git clone -b forcodeplay https://github.com/abagusetty/TAMM.git
cd TAMM
rm -rf build_sycl_$rocm_version
CC=clang CXX=clang++ FC=gfortran cmake $CMAKE_OPTIONS \
-DTAMM_CXX_FLAGS="-O3 -sycl-std=2020 -fsycl -fsycl-device-code-split=per_kernel -fsycl-default-sub-group-size 64 -fno-sycl-id-queries-fit-in-int -Wsycl-strict -ffp-contract=on -fsycl-targets=amdgcn-amd-amdhsa -Xsycl-target-backend -O3 -Xsycl-target-backend --offload-arch=gfx90a -I$MKLROOT/install/include" \
-DTAMM_EXTRA_LIBS="-L$MKLROOT/install/lib -lonemkl -lonemkl_blas_rocblas" \
-H. -Bbuild_sycl_$rocm_version 2>&1 | tee TAMMConfig_${rocm_version}.log 
cd build_sycl_$rocm_version
time make CXXFLAGS+=-w -j16 2>&1 | tee TAMMBuild_${rocm_version}.log
make install
cd ../../

