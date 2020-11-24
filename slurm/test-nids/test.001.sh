#!/bin/bash --login

###
# job name
#SBATCH --job-name=test.001
# specify its partition
#SBATCH --partition=workq
# job stdout file
#SBATCH --output=out/out.001.%J.out
# job stderr file
#SBATCH --error=out/err.001.%J.err
# maximum job time in HH:MM:SS
#SBATCH --time=00:05:00
#SBATCH --nodes=3
# maximum memory
#SBATCH --mem-per-cpu=1G
# run a single task per cpu
###

echo $SLURM_JOB_NODELIST > jobstep1
echo $SLURM_JOB_NUM_NODES >> jobstep1
echo $SLURM_JOB_NAME >> jobstep1

echo $SLURM_JOB_NODELIST > jobstep2
echo $SLURM_JOB_NUM_NODES >> jobstep2
echo $SLURM_JOB_NAME >> jobstep2


srun --relative=0  --nodes=2 --ntasks-per-node=3 step1.sh >> jobstep1  &
srun --relative=2  --nodes=1 --ntasks-per-node=4 step2.sh >> jobstep2

wait
