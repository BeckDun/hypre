#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --partition=ghx4
#SBATCH --time=00:05:00
#SBATCH --job-name=dscg_gpu_array
#SBATCH --account=bdys-dtai-gh
#SBATCH --gpus-per-node=4
#SBATCH --array=0-6

module load craype-accel-nvidia90
module unload gcc-native
module load gcc-native/12
export MPICH_GPU_SUPPORT_ENABLED=1

module list

cd $HOME/hypre/src/build_cuda/test

# Define matrix sizes to test for GPU runs
declare -a SIZES=("64 64 64" "128 128 128" "256 256 256" "320 320 320" "384 384 384" "448 448 448" "512 512 512")

# Get the matrix size for this array job
MATRIX_SIZE=${SIZES[$SLURM_ARRAY_TASK_ID]}

# Create output directory for GPU results
mkdir -p $HOME/hypre_gpu_results

# Run the solver with the specified matrix size
echo "Running GPU ij solver with matrix size: $MATRIX_SIZE"
srun -n 4 -G 4 ./ij -dbg 1 -poutdat 3 -solver 1 -125pt -n $MATRIX_SIZE -P 2 2 1 -memory_device exec_device exec2_device > $HOME/hypre_gpu_results/output_${SLURM_ARRAY_TASK_ID}.log 2>&1

