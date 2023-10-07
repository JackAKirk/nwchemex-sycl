srun -A gen010_sycl -t 1:00:00 -N 1 -n $(($1+1)) ./run.sh ./CCSD_T uracil.json
