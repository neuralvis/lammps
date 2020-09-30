#!/bin/bash --login

###
# job name
#SBATCH --job-name=gpc_lammps.001
# specify its partition
#SBATCH --partition=iv24
# job stdout file
#SBATCH --output=gpc_lammps.001.%J.out
# job stderr file
#SBATCH --error=gpc_lammps.001.%J.err
# On failure, requeue for another try
# maximum job time in HH:MM:SS
#SBATCH --time=06:00:00
#SBATCH --nodes=20
# maximum memory
#SBATCH --mem-per-cpu=1024
# run a single task
#SBATCH --cpus-per-task=1
###

module load PrgEnv-cray
module load cray-mpich
module load perftools-base perftools


srun --exclusive -N 10 -n 480 \
     /home/users/msrinivasa/develop/GPCNET/network_load_test &

srun --exclusive -N 10 -n 480 \
     /home/users/msrinivasa/develop/lammps/build/lmp+trace -i examples/DIFFUSE/in.msd.2d
