#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --partition=ghx4
#SBATCH --time=00:05:00
#SBATCH --job-name=pcg_cpu_gpu
#SBATCH --account=bdys-dtai-gh
#SBATCH --gpus-per-node=4

# Load required modules
module load craype-accel-nvidia90
module unload gcc-native
module load gcc-native/12
export MPICH_GPU_SUPPORT_ENABLED=1

echo "Loaded modules:"
module list

# Navigate to the test directory
cd $HOME/setup_solve/hypre/src/build/test

# Run the modified ij test with PCG (solver 1)
# -pcg_setup_host_solve_device: CPU for setup, GPU for solve
# -solver 1: PCG solver with BoomerAMG preconditioner
# -125pt: 125-point stencil 
# -n 256 256 256: 256^3 grid
# -P 2 2 1: 2x2x1 processor grid
# -memory_device: use device memory
# -exec_device: default GPU execution (will be overridden by our new flag)
srun --cpu-bind=cores --gpu-bind=closest \
     -n 4 -G 4 \
     ./ij \
    -dbg 1 \
    -poutdat 3 \
    -solver 1 \
    -125pt \
    -n 256 256 256 \
    -P 2 2 1 \
    -setup_cpu_solve_gpu
