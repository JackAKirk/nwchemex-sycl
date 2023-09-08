
export MKLROOT=$PWD/oneMKL
export CXX=$(which clang++)
export CC=$(which clang)

export CRAYPE_LINK_TYPE=dynamic

NOW=$(date +"%m-%d-%Y")

export PROJECT_DIR=$PWD/Exachem_sycl_cuda
echo $PROJECT_DIR

export CMAKE_OPTIONS="-DCMAKE_INSTALL_PREFIX=$PROJECT_DIR/install_sycl_cuda -DUSE_OPENMP=OFF -DUSE_DPCPP=ON \
-DBLIS_CONFIG=generic -DBUILD_LIBINT=ON \
-DGCCROOT=/opt/cray/pe/gcc/11.2.0/snos \
	-DCMAKE_BUILD_TYPE=Release"
echo $CMAKE_OPTIONS

mkdir -p $PROJECT_DIR
cd $PROJECT_DIR

#git clone -b forcodeplay https://github.com/abagusetty/TAMM.git
cd TAMM
rm -rf build_sycl_cuda
CC=clang CXX=clang++ FC=gfortran cmake $CMAKE_OPTIONS \
-DTAMM_CXX_FLAGS="-O3 -sycl-std=2020 -fsycl \
-fsycl-device-code-split=per_kernel -fno-sycl-id-queries-fit-in-int \
-Wsycl-strict -ffp-contract=on -fsycl-targets=nvptx64-nvidia-cuda  \
-Xsycl-target-backend --cuda-gpu-arch=sm_80 \
-I$MKLROOT/install/include/" \
-DTAMM_EXTRA_LIBS="-L$MKLROOT/install/lib -lonemkl" \
-H. -Bbuild_sycl_cuda 2>&1 | tee TAMMConfig.log
cd build_sycl_cuda
time make CXXFLAGS+=-w -j16 2>&1 | tee TAMMBuild.log
make install
cd ../../

