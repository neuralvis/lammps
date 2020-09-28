#!/bin/bash --login

###
# job name
#SBATCH --job-name=lmp_diffuse_2d
# job stdout file
#SBATCH --output=lmp_diffuse_2d.%J.out
# job stderr file
#SBATCH --error=lmp_diffuse_2d.%J.err
# On failure, requeue for another try
#SBATCH --requeue
# maximum job time in HH:MM:SS
#SBATCH --time=06:00:00
#SBATCH --nodes=4
# maximum memory
#SBATCH --mem-per-cpu=1024
# run a single task
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=1
###

module load PrgEnv-cray
module load cray-mpich
module load perftools-base perftools

cd /home/users/msrinivasa/develop/lammps
srun build/lmp+sampling -i examples/DIFFUSE/in.msd.2d
