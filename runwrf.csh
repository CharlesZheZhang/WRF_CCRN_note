#!/bin/csh
#
# LSF batch script to run the test MPI code
#
#PBS -N wrfpgw1311
#PBS -A P44513000
#PBS -l walltime=12:00:00
#PBS -l select=20:ncpus=36:mpiprocs=36
#PBS -j oe
#PBS -q economy
#PBS -m abe
#PBS -M zhezhang@ucar.edu

mpiexec_mpt ./wrf.exe >& wrf_pgw_timing.20131120+40
mkdir save20131120
mv rsl.* save20131120
exit
