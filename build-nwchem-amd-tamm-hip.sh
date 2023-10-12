
export CXX=CC
export CC=cc
export FC=ftn
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
-DMODULES=LIBINT \
-DCMAKE_BUILD_TYPE=Release \
-DBLIS_CONFIG=generic \
-DGPU_ARCH=gfx90a \
-DAMDGPU_TARGETS=\"gfx90a\" \
-DGPU_TARGETS=\"gfx90a\""

echo $CMAKE_OPTIONS


mkdir -p $PROJECT_DIR 
cd $PROJECT_DIR

git clone https://github.com/NWChemEx-Project/TAMM
cd TAMM
cmake $CMAKE_OPTIONS  \
-H. -Bbuild_sycl_$rocm_version 2>&1 \
| tee TAMMConfig_${rocm_version}.log 
cd build_sycl_$rocm_version
pwd
make -j16 2>&1 | tee TAMMBuild_${rocm_version}.log
make install
cd ../../

#-DTAMM_EXTRA_LIBS="-L$MKLROOT/install/lib -lonemkl -lonemkl_blas_rocblas" \
