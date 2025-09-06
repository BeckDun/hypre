#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --partition=ghx4
#SBATCH --time=00:05:00
#SBATCH --job-name=dscg_gpu
#SBATCH --account=bdys-dtai-gh
#SBATCH --gpus-per-node=4

module load craype-accel-nvidia90
module unload gcc-native
module load gcc-native/12
export MPICH_GPU_SUPPORT_ENABLED=1

module list


cd $HOME/setup_solve/hypre/src/build/test

srun -n 4 -G 4 ./ij -dbg 1 -poutdat 3 -solver 1 -125pt -n 256 256 256 -P 2 2 1 -memory_device exec_device exec2_device
