#!/bin/bash --login

###
# job name
#SBATCH --job-name=gen_report
# specify its partition
#SBATCH --partition=workq
# job stdout file
#SBATCH --output=gen_report.%J.out
# job stderr file
#SBATCH --error=gen_report.%J.err
# maximum job time in HH:MM:SS
#SBATCH --time=02:00:00
#SBATCH --nodes=1
# maximum memory
#SBATCH --mem=128000
# run a single task
#SBATCH --cpus-per-task=16
###

module restore PrgEnv-cray
module load perftools-base
module load perftools


srun --exclusive -N 1 -n 1 /lus/cls01053/msrinivasa/develop/lammps/perftools/genreport.sh \
     /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.005/data/congested/lmp+tracing+236174-1005t

# /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.005/data/idle/lmp+tracing+235468-1005t
# /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.005/data/congested/lmp+tracing+236174-1005t
# /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.006/data/idle/lmp+tracing+237621-1005t
# /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.006/data/congested/lmp+tracing+238345-1005t
# /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.007/data/idle/lmp+tracing+240216-1005t
# /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.007/data/congested/lmp+tracing+241022-1005t
# /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.008/data/idle/lmp+tracing+211815-1000t
# /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.008/data/congested/lmp+tracing+212856-1000t
# /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.009/data/idle/lmp+tracing+214220-1000t
# /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.009/data/congested/lmp+tracing+215485-1000t
# /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.010/data/idle/lmp+tracing+216945-1000t
# /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.010/data/congested/lmp+tracing+218486-1000t
# /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.011/data/idle/lmp+tracing+220520-1000t
# /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.011/data/congested/lmp+tracing+221981-1000t
# /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.011.2/data/idle/lmp+tracing+236918-1000t
# /lus/cls01053/msrinivasa/develop/lammps/slurm/experiment.011.2/data/congested/lmp+tracing+237774-1000t


# Define experiment name

# wait for a minute till gpcnet primes up the network
wait 


