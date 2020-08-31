# Instrumenting lammps

## Set the environment

```bash
module load PrgEnv-cray
module load cray-mpich
module load perftools-base perftools
```
## Build lammps

```bash
cd lammps
mkdir build
cd build

CC=/opt/cray/pe/craype/2.7.1.4/bin/cc CXX=/opt/cray/pe/craype/2.7.1.4/bin/CC \
cmake ../cmake/ \
-DBUILD_MPI=yes \
-DCMAKE_CXX_FLAGS=-finstrument-loops \
-DCMAKE_BUILD_TYPE=RelWithDebInfo \
-DCMAKE_EXE_LINKER_FLAGS=-finstrument-loops \
-DPKG_ASPHERE=yes \
-DPKG_BODY=yes \
-DPKG_COLLOID=yes \
-DPKG_COMPRESS=yes \
-DPKG_GRANULAR=yes \
-DPKG_MANYBODY=yes \
-DPKG_MISC=yes \
-DPKG_MOLECULE=yes

make -j16
```

## Instrument the executable

```bash
# sampling experiment
pat_build -Drtenv=PAT_RT_SUMMARY=1 -Drtenv=PAT_RT_TRACE_HOOKS=1 lmp

# tracing experiment
pat_build -g mpi -Drtenv=PAT_RT_SUMMARY=1 -Drtenv=PAT_RT_TRACE_HOOKS=1 -u lmp

```

### Notes

* `-Drtenv=PAT_RT_TRACE_HOOKS=1` enables data from compiler hooks (i.e. `-finstrument-loops` above) to be captured in the craypat output
* Using `-Drtenv=PAT_RT_SUMMARY=0` - i.e. disabling runtime summarization and data aggregation will **not** print any loop data

## Run lammps

```bash
salloc -N 4
srun -n 16 build/lmp+pat -i examples/DIFFUSE/in.msd.2d
```

## Running reports

### General Reports

```bash
# general profile report
pat_report -v -f rpt -o report.rpt .

# loop timing report
pat_report -v -O loop_times,loop_callers -f rpt -o loop_overall.rpt .
pat_report -v -O loop_times_all,loop_callers_all -f rpt -o loop_detailed.rpt .

# nid mapping to PE
pat_report -v -O nids -f rpt -o nids.rpt .

# report for a sampling experiment
pat_report -v -O samp_profile+src -f rpt -o samp_profile+src.rpt .

```

### Specific Reports

```bash
# Customized profile report

pat_report -v -d ti%@0.95,ti,tr,Tc -b gr,fu,ni,pe -s table.min_sa_pct=0.95,show_data="csv" -f rpt -o custom_profile_report.rpt .


pat_report -v -d LU@0.0095,LT,tl,Lc@,Lz,La,Lm,LM,Ln -b fu=/.LOOP[.],ni,pe -s table.min_sa_pct=0.95 -s table.missing_dopt=tolerate -s table.overhead=include -s table.total=hide -f rpt -o loop_overall.rpt .

```
