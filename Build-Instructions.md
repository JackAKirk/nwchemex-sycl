# Instructions for building on Crusher/Frontier:

## SYCL (using the hip backend):
Some module customization is necessary:

source setup

In this build we don't use Cray-aware MPI, so
export MPICH_GPU_SUPPORT_ENABLED=0

Note that this assumes there is a built-from-source intel/llvm repo in
$HOME/llvm/. The "setup" file assumes that this is built
with rocm 5.5.1 loaded. Point `ROCM_PATH` to the rocm install path.
Configuration of intel/llvm is as follows:

python3 llvm/buildbot/configure.py --hip -o build --cmake-opt=-DSYCL_BUILD_PI_HIP_ROCM_DIR=$ROCM_PATH
python3 llvm/buildbot/compile.py -o build

Then update your paths accordingly, e.g.:

export DPCPP_HOME=~/llvm
export PATH=$DPCPP_HOME/build/bin:$PATH
export PATH=$DPCPP_HOME/build/utils:$PATH
export LD_LIBRARY_PATH=$DPCPP_HOME/build/lib:$LD_LIBRARY_PATH


Then build oneMKL:
bash build-mkl.sh
### add oneMKL to LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$PWD/oneMKL/install/lib:$LD_LIBRARY_PATH
### build tamm
bash build-nwchem-cuda-tamm.sh
### build CC
bash build-nwchem-cuda-CC.sh

On crusher/frontier the executable and the input file need to be copied to a writeable filesystem, e.g., somewhere on /lustre.

Exachem_sycl_rocm/install_sycl_rocm/bin contains CCSD_T . Copy the desired input file, e.g. Exachem_sycl_rocm/CoupledCluster/inputs/uracil.json
to the bin directory and edit it as desired:

Then you can the program via e.g.

bash srun.sh N

or otherwise. Where N is the number of GPUs to use. Note that srun.sh uses run.sh to set affinity to a particulary GPU based on MPI rank. There may be better ways to do this.

This has been tested only on a single node.


## HIP:
source setup.hip
bash build-nwchem-amd-tamm-hip.sh
bash build-nwchem-amd-CC-hip.sh

Run instructions are the same as for the SYCL build.


Running the big problem:
sub.sh or sub-hip.sh will queue batch jobs for the problem in the paper
"Towards Cross-Platform Portability of Coupled-Cluster Methods with Perturbative Triples using SYCL"

Modifications will be required for the correct account and location of the setup script and executable.
