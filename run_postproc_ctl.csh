#!/bin/tcsh
#SBATCH -J post2013
#SBATCH -n 1
#SBATCH --ntasks-per-node=1
#SBATCH -t 24:00:00
#SBATCH -A P44513000
#SBATCH -p dav
#SBATCH -e post2013.err.%J
#SBATCH -o post2013.out.%J

### Initialize the Slurm environment
   source /glade/u/apps/opt/slurm_init/init.csh

   module purge
   module load ncl
   module load nco
 
   set MMs = ( 09 10 11 )
   set YYYY = 2013
   set EXP = "CTL"

  foreach MM ( ${MMs} )
     mkdir /glade/scratch/zhezhang/WRF_CCRN/post_data/${EXP}/${YYYY}${MM}
     set month = `echo ${MM} | bc`
     set month = `printf %02d ${MM}`

     echo "Start 3d ... " `date '+DATE: %m/%d/%y  TIME:%H:%M:%S'`
     ./make_WRF_3d_files.csh ${EXP} ${YYYY} ${MM}
  end
