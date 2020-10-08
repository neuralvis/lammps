#!/bin/bash

pat_report -v \
	   -d ti%@0.95,ti,max_ti,min_ti,tr,Tc \
	   -b gr,ni,pe=HIDE  \
	   -s table.min_sa_pct=0.95 \
	   -f rpt -o ALL_GROUPS.rpt .

pat_report -v \
	   -d ti%@0.95,ti,max_ti,min_ti,tr,Tc \
	   -b gr=MPI,ni,pe=HIDE  \
	   -s table.min_sa_pct=0.95,table.total=hide,show_data='csv' \
	   -f rpt -o MPI.rpt .

pat_report -v \
	   -d ti%@0.95,ti,max_ti,min_ti,tr,Tc \
	   -b gr=MPI_SYNC,ni,pe=HIDE  \
	   -s table.min_sa_pct=0.95,table.total=hide,show_data='csv' \
	   -f rpt -o MPI_SYNC.rpt .

pat_report -v \
	   -d ti%@0.95,ti,max_ti,min_ti,tr,Tc \
	   -b gr=USER,ni,pe=HIDE  \
	   -s table.min_sa_pct=0.95,table.total=hide,show_data='csv' \
	   -f rpt -o USER.rpt .
