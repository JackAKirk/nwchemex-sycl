#!/bin/bash
# hard code 8 for #gpus
export ROCR_VISIBLE_DEVICES=$(( $SLURM_LOCALID % 8 ))
echo "Running $* on GPU $SLURM_LOCALID"
exec $*
