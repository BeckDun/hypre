#!/bin/bash

### INFO: 36 cores per node

### Input: 

### LSF syntax
#SBATCH --nodes=64
#SBATCH --partition=pbatch
##default time limit is 30m
#SBATCH --time=60

#SBATCH --job-name=geraldc-topo-per-lvl
#SBATCH --output=topo_per_lvl_%j.out

### Shell scripting
HYPRE=~/bienz_hypre
# check for binary
if [ ! "$(ls "${HYPRE}/src/test/cxx_ij")" ]
then
    echo "cxx_ij hypre_std driver not found"
    exit 1
fi

# print run info
date; hostname
echo -n 'Run output directory: '; echo $PWD
echo -n 'JobID: '; echo $LSB_JOBID

nodes=64
ranks=2048
n=512
p1=16
p2=16
p3=8

for RUN in {1..3}; do
    echo "Scale: " $SCALE ", RUN: " $RUN
    echo "Ranks: " $ranks ", nodes: " $nodes ", n: " $n ", p: " $p1 " " $p2 " " $p3
    srun -N $nodes -n $ranks ${HYPRE}/src/test/cxx_ij -rlx 6 -CF 0 -hmis -interptype 6 -Pmx 5 -agg_nl 1 -solver 0 -n ${n} ${n} ${n} -P ${p1} ${p2} ${p3} > per_lvl_${RUN}.txt
done
