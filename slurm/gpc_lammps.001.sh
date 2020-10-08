#!/bin/bash --login

###
# job name
#SBATCH --job-name=gpc_lammps.001
# specify its partition
#SBATCH --partition=workq
# job stdout file
#SBATCH --output=stdout/gpc_lammps.001.%J.out
# job stderr file
#SBATCH --error=stdout/gpc_lammps.001.%J.err
# maximum job time in HH:MM:SS
#SBATCH --time=06:00:00
#SBATCH --nodes=100
# maximum memory
#SBATCH --mem-per-cpu=512
# run a single task
#SBATCH --cpus-per-task=1
###

# Begin experiment
export EXPERIMENT_DIR=experiment.001/90_10
export EXPERIMENT_METAFILE=$EXPERIMENT_DIR/readme.txt
mkdir -p $EXPERIMENT_DIR

echo "Experiment 001">>$EXPERIMENT_METAFILE
echo "GPCNet Allocation: 90%, 90 nodes, 10 PPN">>$EXPERIMENT_METAFILE
echo "LAMMPS Allocation: 10%, 10 nodes, 4 PPN">>$EXPERIMENT_METAFILE

echo "Idle run starttime: "`date -uI'seconds'`>>$EXPERIMENT_METAFILE

export PAT_RT_EXPDIR_BASE=$EXPERIMENT_DIR/idle

mkdir -p $PAT_RT_EXPDIR_BASE

# Run lammps without congestion with 4 ppn
srun --exclusive -N 10 -n 40 \
    /home/users/msrinivasa/develop/lammps/build/lmp+tracing \
    -i /home/users/msrinivasa/develop/lammps/examples/DIFFUSE/in.msd.2d \
    > $PAT_RT_EXPDIR_BASE/lammps.idle.out


# Run gpcnet on 90% of allocation with 10 ppn
# srun --exclusive -N 834  -n 8340 \
#   /home/users/msrinivasa/develop/GPCNET/network_load_test > gpc.out &

# wait till gpcnet primes up the network
# sleep 60

# Run lammps with 4 ppn
# srun --exclusive -N 93 -n 372 \
#     /home/users/msrinivasa/develop/lammps/build/lmp+tracing \
#     -i /home/users/msrinivasa/develop/lammps/examples/DIFFUSE/in.msd.2d > lammps.out

# wait till all jobsteps finish
# wait

# sbatch cmd on Shandy that works [October 6, 2020]
# sbatch --exclude=nid001421,nid001382,nid001297,nid001260,nid001464 gpc_lammps.90_10.shandy.sh
