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
#SBATCH --nodes=900
# maximum memory
#SBATCH --mem-per-cpu=512
# run a single task
#SBATCH --cpus-per-task=1
###

module restore PrgEnv-cray

# Define allocations and experiment name
export EXPERIMENT_NAME=experiment.002

export NODE_COUNT=900
export LAMMPS_NC=90
export LAMMPS_PE_COUNT=360
export GPCNET_NC=810
export GPCNET_PE_COUNT=8100

# Begin experiment
export EXPERIMENT_DIR=/lus/cls01053/msrinivasa/data/experiments/$EXPERIMENT_NAME
export EXPERIMENT_METAFILE=$EXPERIMENT_DIR/README.txt
mkdir -p $EXPERIMENT_DIR

# Write metadata into a README file for the experiment
echo "Experiment 001">$EXPERIMENT_METAFILE
echo "GPCNet Allocation: 90%, 90 nodes, 10 PPN">>$EXPERIMENT_METAFILE
echo "LAMMPS Allocation: 10%, 10 nodes, 4 PPN">>$EXPERIMENT_METAFILE

# Define a few craypat related environment variables for this jobstep
export PAT_RT_EXPDIR_BASE=$EXPERIMENT_DIR/idle
export PAT_RT_EXPFILE_MAX=$LAMMPS_PE_COUNT
mkdir -p $PAT_RT_EXPDIR_BASE

echo "Idle run starttime: "`date -uI'seconds'`>>$EXPERIMENT_METAFILE
# Run lammps without congestion with 4 ppn
srun --exclusive -N $LAMMPS_NC -n $LAMMPS_PE_COUNT \
    /home/users/msrinivasa/develop/lammps/build/lmp+tracing \
    -i /home/users/msrinivasa/develop/lammps/examples/DIFFUSE/in.msd.2d \
    > $PAT_RT_EXPDIR_BASE/lammps.idle.out
echo "Idle run endtime: "`date -uI'seconds'`>>$EXPERIMENT_METAFILE

# wait for 30 seconds 
sleep 30

# Define a few craypat related environment variables for this jobstep
export PAT_RT_EXPDIR_BASE=$EXPERIMENT_DIR/congested
export PAT_RT_EXPFILE_MAX=$LAMMPS_PE_COUNT
mkdir -p $PAT_RT_EXPDIR_BASE


echo "GPCNET run starttime: "`date -uI'seconds'`>>$EXPERIMENT_METAFILE
# Run gpcnet on its allocation with 10 ppn
srun --exclusive -N $GPCNET_NC  -n $GPCNET_PE_COUNT \
  /home/users/msrinivasa/develop/GPCNET/network_load_test > $PAT_RT_EXPDIR_BASE/gpcnet.out &

# wait for a minute till gpcnet primes up the network
sleep 30


echo "Congested LAMMPS run starttime: "`date -uI'seconds'`>>$EXPERIMENT_METAFILE
# Run lammps with congestion with 4 ppn
srun --exclusive -N $LAMMPS_NC -n $LAMMPS_PE_COUNT \
    /home/users/msrinivasa/develop/lammps/build/lmp+tracing \
    -i /home/users/msrinivasa/develop/lammps/examples/DIFFUSE/in.msd.2d \
    > $PAT_RT_EXPDIR_BASE/lammps.congested.out
echo "Congested LAMMPS run endtime: "`date -uI'seconds'`>>$EXPERIMENT_METAFILE

# wait till all jobsteps finish
wait
# now we know GPCNET is done
echo "GPCNET run endtime: "`date -uI'seconds'`>>$EXPERIMENT_METAFILE

# sbatch cmd on Shandy that works [October 6, 2020]
# sbatch --exclude=nid001007,nid001023,nid001056,nid001026,nid001069,nid001171,nid001196 gpc_lammps.001.sh

# sbatch --exclude=nid001007,nid001023,nid001056,nid001026,nid001069,nid001171,nid001196,nid001492,nid001868,nid001451,nid001416,nid001532,nid001233,nid001584,nid001847,nid001752,nid001811,nid001720,nid001386,nid001125,nid001533,nid001539,nid001753,nid001711,nid001323,nid001734,nid001785,nid001796,nid001440,nid001625,nid001456,nid001687,nid001727  gpc_lammps.001.sh
