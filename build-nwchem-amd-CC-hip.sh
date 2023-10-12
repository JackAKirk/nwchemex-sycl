export HIP_PATH=$ROCM_PATH/hip

export CRAYPE_LINK_TYPE=dynamic

declare rocm_version="${ROCM_PATH}"
prefix="/opt/rocm-"
rocm_version=${rocm_version#"$prefix"}
echo $rocm_version

NOW=$(date +"%m-%d-%Y")

export PROJECT_DIR=$PWD/Exachem_hip_rocm
echo $PROJECT_DIR

echo $ROCM_PATH
declare rocm_version="${ROCM_PATH}"
declare rocm_version=${rocm_version#"/opt/rocm-"}
echo $rocm_version

export CMAKE_OPTIONS=\
"-DCMAKE_INSTALL_PREFIX=$PROJECT_DIR/install_hip_rocm \
-DUSE_OPENMP=OFF -DUSE_HIP=ON -DROCM_ROOT=${ROCM_PATH} \
-DENABLE_COVERAGE=FALSE \
-DGCCROOT=/opt/cray/pe/gcc/12.2.0/snos \
-DCMAKE_BUILD_TYPE=Release \
-DHDF5_ROOT=$HDF5_ROOT \
-DBUILD_TESTS=OFF \
-DBUILD_LIBINT=ON \
-DCMAKE_BUILD_TYPE=Release \
-DBLIS_CONFIG=generic \
-DGPU_ARCH=gfx90a \
-DAMDGPU_TARGETS=\"gfx90a\" \
-DGPU_TARGETS=\"gfx90a\""

echo $CMAKE_OPTIONS

#mkdir -p $PROJECT_DIR
cd $PROJECT_DIR


#git clone -b CC https://github.com/NWChemEx-Project/CoupledCluster
git clone -b lfmeadow-patches https://github.com/lfmeadow/CoupledCluster.git
cd CoupledCluster
mkdir build_hip
cd build_hip
CC=cc CXX=CC FC=ftn cmake $CMAKE_OPTIONS \
-DTAMM_CXX_FLAGS="-O3 -ffp-contract=on"  \
 ..
make -j 16
make install
#-DTAMM_EXTRA_LIBS="-L$MKLROOT/install/lib -lonemkl -lonemkl_blas_rocblas \
#${CRAY_XPMEM_POST_LINK_OPTS} -lxpmem \
#${PE_MPICH_GTL_DIR_amd_gfx90a} ${PE_MPICH_GTL_LIBS_amd_gfx90a} " \
