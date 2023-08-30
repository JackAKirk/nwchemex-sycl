export MKLROOT=$HOME/oneMKL
export CXX=$(which clang++)
export CC=$(which clang)
export LIBRARY_PATH=/opt/rocm-4.5.2/llvm/lib/clang/13.0.0/lib/linux/:$LIBRARY_PATH
export HIP_PATH=/opt/rocm-4.5.2/hip

export CRAYPE_LINK_TYPE=dynamic

ROCM_PATH=$SYCL_BUILD_PI_HIP_ROCM_DIR
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

export CMAKE_OPTIONS="-DCMAKE_INSTALL_PREFIX=$PROJECT_DIR/install_sycl_rocm -DUSE_OPENMP=OFF -DUSE_DPCPP=ON -DROCM_ROOT=${ROCM_PATH} -DGCCROOT=/opt/slurm/gcc/12.2.0 \
-DBLIS_CONFIG=generic -DBUILD_LIBINT=ON \
        -DCMAKE_BUILD_TYPE=Release"
echo $CMAKE_OPTIONS
#-DBUILD_TESTS=OFF \

#mkdir -p $PROJECT_DIR
cd $PROJECT_DIR


git clone -b CC https://github.com/NWChemEx-Project/CoupledCluster
cd CoupledCluster
mkdir build_sycl
cd build_sycl
CC=clang CXX=clang++ FC=gfortran cmake $CMAKE_OPTIONS \
-DTAMM_CXX_FLAGS="-O3 -sycl-std=2020 -fsycl -fsycl-device-code-split=per_kernel -fsycl-default-sub-group-size 64 -fno-sycl-id-queries-fit-in-int -Wsycl-strict -ffp-contract=on -fsycl-targets=amdgcn-amd-amdhsa -Xsycl-target-backend -O3 -Xsycl-target-backend --offload-arch=gfx1030 " \
-DTAMM_EXTRA_LIBS="-L$MKLROOT/install/lib -lonemkl -lonemkl_blas_rocblas"  ..
make
make install
