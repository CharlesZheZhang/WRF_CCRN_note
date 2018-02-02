#!/bin/sh
#
# LSF batch script to run the test MPI code
#
#PBS -N met1412
#PBS -A P44513000
#PBS -l walltime=12:00:00
#PBS -l select=16:ncpus=32:mpiprocs=32
#PBS -j oe
#PBS -q economy
#PBS -m abe
#PBS -M zhezhang@ucar.edu

mpiexec_mpt ./metgrid.exe

exit
