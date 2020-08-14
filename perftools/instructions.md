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
```

## Instrument the executable

```bash
# sampling experiment
pat_build -Drtenv=PAT_RT_TRACE_HOOKS=1  lmp

# tracing experiment
pat_build -g mpi  -Drtenv=PAT_RT_TRACE_HOOKS=1 -u lmp

```

## Run lammps

```bash
salloc -N 4
srun -n 16 build/lmp+pat -i examples/DIFFUSE/in.msd.2d
```

## Running reports

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


## LAMMPS Instructions from Sam Partee

 Below are some notes on building and running some LAMMPS examples


### Installation

  - Clone the repo (or download a specific release)
    ```bash
    git clone https://github.com/lammps/lammps.git
    ```

  - Setup Cicero environment
    ```bash\include{LAMMPS Instructions}
    module swap PrgEnv-cray PrgEnv-gnu/6.0.8
    ```

  - Setup the CMake
    ```bash
    cd lammps
    cd cmake
    mkdir compile
    cd compile
    ```

  - call cmake
    ```bash
    CC=/opt/cray/pe/craype/2.7.1.4/bin/cc CXX=/opt/cray/pe/craype/2.7.1.4/bin/CC cmake ../ -DBUILD_MPI=yes
    ```

  - call make\include{LAMMPS Instructions}
  ```bash
  make
  ```

### Running an Example

   - Fairly simple to run any of the examples
   ```bash
   cd lammps/examples/<whichever example you would like>
   #get an allocation#
   srun /path/to/lmp/exe/ -n 200 -i input_file.in
   ```

## SmartSim

### Documentation

  - The docs are hosted on an internal cray server so you have to be on the vpn to view
  - [link](http://web/~spartee/smartsim/)

### LAMMPS and SmartSim

  - LAMMPS is used in many smartsim examples and detailed in the documentation
  - There are two places where the documentation gives examples of SmartSim running LAMMPS, both
    are in the examples section

      - *Generating Ensembles*
      - *Extracting data from Compiled Simulations*

  - These will also give you a good idea about how to run LAMMPS but also how to use SmartSim


## Other

  - [LAMMPS Repo](https://github.com/lammps/lammps)
  - [LAMMPS Developer Docs](https://lammps.sandia.gov/doc/Developer.pdf)
  - [LAMMPS Examples](https://github.com/lammps/lammps/tree/master/examples)
