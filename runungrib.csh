#!/bin/csh
#
# LSF batch script to run the test MPI code
#
#PBS -N un1501
#PBS -A P44513000                      
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mpiprocs=1
#PBS -j oe
#PBS -q regular 
#PBS -m abe
#PBS -M zhezhang@ucar.edu

ln -sf ungrib/Variable_Tables/Vtable.ERA-interim.pl Vtable

cp namelist.wps_erai4p namelist.wps
./link_grib.csh /glade/p/rda/data/ds627.0/ei.oper.an.pl/2015{01,02,03,04,05,06,07,08,09,10}/ei.oper.an.pl*
#mpiexec_mpt ./ungrib.exe
./ungrib.exe
#rm GRIBFILE.*
#rm PFILE*

cp namelist.wps_erai4s namelist.wps
./link_grib.csh /glade/p/rda/data/ds627.0/ei.oper.an.sfc/2015{01,02,03,04,05,06,07,08,09,10}/ei.oper.an.sfc*
#mpiexec_mpt ./ungrib.exe
./ungrib.exe
#rm GRIBFILE.*
#rm PFILE*

exit
