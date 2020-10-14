#!/bin/bash

module load perftools-base perftools

DATA_DIR=$1

pat_report -v \
	   -i /home/users/msrinivasa/develop/lammps/build/lmp+tracing \
	   -d ti%@0.95,ti,max_ti,min_ti,tr,Tc \
	   -b gr,ni,pe=HIDE  \
	   -s table.min_sa_pct=0.95 \
	   -f rpt -o $DATA_DIR\ALL_GROUPS.rpt $DATA_DIR

pat_report -v \
   	   -i /home/users/msrinivasa/develop/lammps/build/lmp+tracing \
	   -d ti%@0.95,ti,max_ti,min_ti,tr,Tc \
	   -b gr=MPI,ni,pe=HIDE  \
	   -s table.min_sa_pct=0.95,table.total=hide,show_data='csv' \
	   -f rpt -o $DATA_DIR\MPI.rpt $DATA_DIR

pat_report -v \
	   -i /home/users/msrinivasa/develop/lammps/build/lmp+tracing \
	   -d ti%@0.95,ti,max_ti,min_ti,tr,Tc \
	   -b gr=MPI_SYNC,ni,pe=HIDE  \
	   -s table.min_sa_pct=0.95,table.total=hide,show_data='csv' \
	   -f rpt -o $DATA_DIR\MPI_SYNC.rpt $DATA_DIR

pat_report -v \
	   -i /home/users/msrinivasa/develop/lammps/build/lmp+tracing \
	   -d ti%@0.95,ti,max_ti,min_ti,tr,Tc \
	   -b gr=USER,ni,pe=HIDE  \
	   -s table.min_sa_pct=0.95,table.total=hide,show_data='csv' \
	   -f rpt -o $DATA_DIR\USER.rpt $DATA_DIR
