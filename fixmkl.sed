sed -e '/CLANGRT_BUILTINS:FILEPATH/s,=.*,=/opt/rocm-5.4.0/llvm/lib/clang/15.0.0/lib/linux/libclang_rt.builtins-x86_64.a,' <oneMKL/build//CMakeCache.txt >x
