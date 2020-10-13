#!/bin/bash --login

###
# job name
#SBATCH --job-name=gpc_lammps.002
# specify its partition
#SBATCH --partition=workq
# job stdout file
#SBATCH --output=gpc_lammps.002.%J.out
# job stderr file
#SBATCH --error=gpc_lammps.002.%J.err
# maximum job time in HH:MM:SS
#SBATCH --time=06:00:00
#SBATCH --nodes=500
# maximum memory
#SBATCH --mem-per-cpu=512
# run a single task
#SBATCH --cpus-per-task=1
###

module restore PrgEnv-cray
module load perftools-base
module load perftools

# Define experiment name
export EXPERIMENT_NAME=experiment.002

# Define allocations
export TOTAL_NC=500
export LAMMPS_NC=50
export LAMMPS_PE_COUNT=200
export GPCNET_NC=450
export GPCNET_PE_COUNT=4500

# Define directories
export APP_BASE_DIR=/lus/cls01053/msrinivasa/develop
export DATA_DIR=./data
export EXPERIMENT_METAFILE=$EXPERIMENT_NAME.README.txt
mkdir -p $DATA_DIR

# Write metadata into a README file for the experiment
echo $EXPERIMENT_NAME>$EXPERIMENT_METAFILE
echo "GPCNet Allocation: 90%, 90 nodes, 10 PPN">>$EXPERIMENT_METAFILE
echo "LAMMPS Allocation: 10%, 10 nodes, 4 PPN">>$EXPERIMENT_METAFILE

# Define a few craypat related environment variables for this jobstep
export PAT_RT_EXPDIR_BASE=$DATA_DIR/idle
export PAT_RT_EXPFILE_MAX=$LAMMPS_PE_COUNT
mkdir -p $PAT_RT_EXPDIR_BASE

echo "Idle run starttime: "`date -uI'seconds'`>>$EXPERIMENT_METAFILE
# Run lammps without congestion with 4 ppn
srun --exclusive -N $LAMMPS_NC -n $LAMMPS_PE_COUNT \
    $APP_BASE_DIR/lammps/build/lmp+tracing \
    -i $APP_BASE_DIR/lammps/examples/DIFFUSE/in.msd.2d \
    > $PAT_RT_EXPDIR_BASE/lammps.idle.out
echo "Idle run endtime: "`date -uI'seconds'`>>$EXPERIMENT_METAFILE

# wait for 30 seconds
sleep 30

# Define a few craypat related environment variables for this jobstep
export PAT_RT_EXPDIR_BASE=$DATA_DIR/congested
export PAT_RT_EXPFILE_MAX=$LAMMPS_PE_COUNT
mkdir -p $PAT_RT_EXPDIR_BASE


echo "GPCNET run starttime: "`date -uI'seconds'`>>$EXPERIMENT_METAFILE
# Run gpcnet on its allocation with 10 ppn
srun --exclusive -N $GPCNET_NC  -n $GPCNET_PE_COUNT \
     $APP_BASE_DIR/GPCNET/network_load_test > $PAT_RT_EXPDIR_BASE/gpcnet.out &

# wait for a minute till gpcnet primes up the network
sleep 30


echo "Congested LAMMPS run starttime: "`date -uI'seconds'`>>$EXPERIMENT_METAFILE
# Run lammps with congestion with 4 ppn
srun --exclusive -N $LAMMPS_NC -n $LAMMPS_PE_COUNT \
     $APP_BASE_DIR/lammps/build/lmp+tracing \
     -i $APP_BASE_DIR/lammps/examples/DIFFUSE/in.msd.2d \
    > $PAT_RT_EXPDIR_BASE/lammps.congested.out
echo "Congested LAMMPS run endtime: "`date -uI'seconds'`>>$EXPERIMENT_METAFILE

# wait till all jobsteps finish
wait
# now we know GPCNET is done
echo "GPCNET run endtime: "`date -uI'seconds'`>>$EXPERIMENT_METAFILE

# Clean up GPCNET output, since we don't need it
rm *.dat
rm *.rec

# Clean up the lammps log output (it is redundant)
rm log.lammps



# sbatch cmd on Shandy that works [October 6, 2020]

# sbatch --exclude=nid001023,nid001143,nid001297,nid001307,nid001553,nid001569,nid001734,nid001838,nid001842,nid001864,nid001881,nid001885,nid001887,nid001900,nid001944,nid001965,nid002000  gpc_lammps.002.sh
