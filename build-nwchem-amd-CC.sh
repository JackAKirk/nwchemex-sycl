export MKLROOT=$HOME/nwchemex-sycl/oneMKL
export CXX=$(which clang++)
export CC=$(which clang)
export HIP_PATH=$ROCM_PATH/hip

export CRAYPE_LINK_TYPE=dynamic

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

export CMAKE_OPTIONS="-DCMAKE_INSTALL_PREFIX=$PROJECT_DIR/install_sycl_rocm \
-DUSE_OPENMP=OFF -DUSE_DPCPP=ON -DROCM_ROOT=${ROCM_PATH} \
-DGCCROOT=/opt/cray/pe/gcc/12.2.0/snos \
-DBLIS_CONFIG=generic -DBUILD_LIBINT=ON \
        -DHDF5_ROOT=$HDF5_ROOT \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo"
echo $CMAKE_OPTIONS
#-DBUILD_TESTS=OFF \

mkdir -p $PROJECT_DIR
cd $PROJECT_DIR


#git clone -b CC https://github.com/NWChemEx-Project/CoupledCluster
# temp until PR is incorporated
#git clone -b lfmeadow-patches https://github.com/lfmeadow/CoupledCluster.git
git clone -b CC-updates https://github.com/JackAKirk/CoupledCluster.git
cd CoupledCluster
mkdir build_sycl
cd build_sycl
CC=clang CXX=clang++ FC=gfortran cmake $CMAKE_OPTIONS \
-DTAMM_CXX_FLAGS="-O3 -sycl-std=2020 -fsycl -fsycl-device-code-split=per_kernel -fsycl-default-sub-group-size 64 \
-fno-sycl-id-queries-fit-in-int -Wsycl-strict -ffp-contract=on -fsycl-targets=amdgcn-amd-amdhsa \
-Xsycl-target-backend --offload-arch=gfx90a " \
-DTAMM_EXTRA_LIBS="-L$MKLROOT/install/lib -lonemkl -lonemkl_blas_rocblas \
${CRAY_XPMEM_POST_LINK_OPTS} -lxpmem \
${PE_MPICH_GTL_DIR_amd_gfx90a} ${PE_MPICH_GTL_LIBS_amd_gfx90a} " \
 ..
make -j 16
make install
