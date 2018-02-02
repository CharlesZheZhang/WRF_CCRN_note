#!/bin/csh
#
# LSF batch script to run the test MPI code
#
#PBS -N realpgw1309
#PBS -A P44513000
#PBS -l walltime=12:00:00
#PBS -l select=16:ncpus=16:mpiprocs=16
#PBS -j oe
#PBS -q economy
#PBS -m abe
#PBS -M zhezhang@ucar.edu

mpiexec_mpt ./real.exe >& real_timing_pgw.1309-1312
mkdir real201309
mv rsl.* real201309
exit
~         
