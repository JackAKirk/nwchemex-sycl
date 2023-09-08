export MKLROOT=$HOME/oneMKL
export CXX=$(which clang++)
export CC=$(which clang)

export CRAYPE_LINK_TYPE=dynamic

export PROJECT_DIR=$PWD/Exachem_sycl_cuda
echo $PROJECT_DIR

export CMAKE_OPTIONS="-DCMAKE_INSTALL_PREFIX=$PROJECT_DIR/install_sycl_cuda -DUSE_OPENMP=OFF \
-DUSE_DPCPP=ON -DROCM_ROOT=${ROCM_PATH} -DGCCROOT=/opt/cray/pe/gcc/11.2.0/snos \
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
-DTAMM_CXX_FLAGS="-O3 -sycl-std=2020 -fsycl -fsycl-device-code-split=per_kernel \
-fno-sycl-id-queries-fit-in-int -Wsycl-strict -ffp-contract=on \
-fsycl-targets=nvptx64-nvidia-cuda -Xsycl-target-frontend -O3 \
-Xsycl-target-backend --cuda-gpu-arch=sm_80"  \
-DTAMM_EXTRA_LIBS="-L$MKLROOT/install/lib -lonemkl" ..
make
make install
