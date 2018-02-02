#!/bin/csh
#
# Project : WRF4KM_canada
# #
# # Purpose : Make subset of WRF output files.
# # Resulting files contain only 3D variables.
# #
# # Usage : ./make_WRF_3d_files_d01.csh EXP YYYY MM
# #         EXP = CTL / PGW


 module load nco
 module load netcdf
 module load ncl

#-----------------------------------------------------------------------------------------------
# Arguments
#-----------------------------------------------------------------------------------------------
 set  EXP = ${argv[1]}
 set  YYYY = ${argv[2]}
 set  MM   = ${argv[3]}

#-----------------------------------------------------------------------------------------------
# List of variables to save
#-----------------------------------------------------------------------------------------------

 #-------- 3D data (3-hourly) -----------------------#
 set var3d = "Times,PH,PHB,T,P,PB,U,V,W,QVAPOR,QCLOUD,QRAIN,QSNOW,QGRAUP,QICE,CLDFRA"
# set var3d_conc = "QNICE,QNRAIN"

#-----------------------------------------------------------------------------------------------
# Path to input and output
#-----------------------------------------------------------------------------------------------
    set indir   = "/glade/scratch/zhezhang/WRF_CCRN/WRF_${EXP}/run_wrf${YYYY}/output/"
    set outdir  = "/glade/scratch/zhezhang/WRF_CCRN/post_data/${EXP}/${YYYY}${MM}/"



#-----------------------------------------------------------------------------------------------
# Check if input, output, and wrfout directory exists
#-----------------------------------------------------------------------------------------------

 if (! -d ${indir}) then
    echo "ERROR : ${indir} does not exist"
    goto ERROR
 else
 endif

 if (! -d ${outdir}) then
    mkdir ${outdir}
 else
 endif

#-----------------------------------------------------------------------------------------------
# Format YYYY and MM
#-----------------------------------------------------------------------------------------------
 set MM = `echo ${MM} | bc`
 set MM = `printf %02d ${MM}`
 set YYYY = `echo ${YYYY} | bc`
 set YYYY = `printf %04d ${YYYY}`

#-----------------------------------------------------------------------------------------------
# Setting number of days for checking total number of files to be processed
#    MM    = ( "10" "11" "12" "01" "02" "03" "04" "05" "06" "07" "08" "09")
#    ndays = (  31   30   31   31   28   31   30   31   30   31   31   30 )
#    Leap_years = 2000, 2004, 2008, 2012, ... but no leap years in GCM runs.
#-----------------------------------------------------------------------------------------------

 if ( ${MM} == 10 | ${MM} == 12 | ${MM} == 01 | ${MM} == 03 | ${MM} == 05 | ${MM} == 07 | ${MM} == 08 ) then 
    set nDays = 31
 else
    set nDays = 30
 endif

 if ( ${MM} == 02 ) then
    set nDays = 28
#    if ( ${YYYY} == 2004 | ${YYYY} == 2008 | ${YYYY} ==2012 ) then
#        set nDays = 29
#    endif 
endif


 ##----- test -----#
#set nDays = 8

 set nFiles3D   = `echo "${nDays}" | bc`
 echo " ... number of days in the month             : nDays  = ${nDays}"
 echo " ... number of files to be processed for 3D  : nFiles = ${nFiles3D}"

#-----------------------------------------------------------------------------------------------
# Save 3D variables : 3-hourly data. 00, 03, 06, 09, 12, 15, 18, 21 UTC
#-----------------------------------------------------------------------------------------------

 set INPUT_FILE = `/bin/ls -1 ${indir}wrfout_d01_${YYYY}-${MM}-*`

 if ( $#INPUT_FILE != ${nFiles3D} ) then
    echo " ... error number of files does not equall to ${nFiles3D}"
    goto ERROR
 endif

 foreach file ( ${INPUT_FILE} )
         set outfile = `echo ${file} | awk -F'/' '{print $NF}' | sed s/wrfout/wrf3d/`
         set outfile = ${outdir}${outfile}

         echo " .... input file  : ${file}"
         echo " .... output file : ${outfile}"

         if ( -e ${outfile} ) then
            echo " ... output already exists. Moving on to the next file."
            goto NEXT3D
         endif

         #-------------------------------------------------------#
         # save 3d data                                          #
         #-------------------------------------------------------#
         ncrcat -h -O -v${var3d} ${file} ${outfile}

         if ( ${status} != 0 ) then
            echo " .... ERROR : ncrcat of 3d data for ${file}"
            goto ERROR
         endif
         #-------------------------------------------------------#
         # compute geopotential height, total pressure (totP),   #
         # and T in deg K                                        #
         #-------------------------------------------------------#
         ncap2 -h -A -v -s 'Z=PH; Z=(PH + PHB)/double(9.81)' ${outfile} ${outfile}
         ncap2 -h -A -v -s 'TK=T; TK=(T+double(300.0))/((double(100000.0)/(P+PB))^double((287.0/(7.0*(287.0/2.0)))))' ${outfile} ${outfile}
         ncap2 -h -A -v -s 'P=P+PB' ${outfile} ${outfile}

         ncatted -h -a description,Z,m,c,"Geopotential height (PH + PHB)/9.81" ${outfile}
         ncatted -h -a units,Z,m,c,"meters" ${outfile}

         ncatted -h -a description,TK,m,c,"Air temperature" ${outfile}
         ncatted -h -a units,TK,m,c,"deg K" ${outfile}

         ncatted -h -a description,P,m,c,"Total pressure (P0+PB)" ${outfile}

         ncrcat -h -O -x -vPB,PH,PHB,T ${outfile} ${outfile}
         #----------------- Clean up ----------------------------#
         if ( -e ${outfile} ) then
            set file_date = `date '+%Y%m%d'`
            ncatted -h -a Source_Code,global,a,c,"make_WRF_3d_files.csh" ${outfile}
            ncatted -h -a FileGenerated,global,a,c,${file_date} ${outfile}
            ncatted -h -a Project,global,a,c,"WRF4KM_canada" ${outfile}
            ncatted -h -a Division,global,a,c,"GIWS, UofS" ${outfile}
            ncatted -h -a Contacts,global,a,c,"SOPAN KURKUTE (kurkute.sopan@usask.ca)" ${outfile}
         else
            echo " .... ERROR : no output file ${outfile}"
            goto ERROR
         endif

         #----------------- Compress file -----------------------#
         ncks -O -4 -L 1 ${outfile} ${outfile}
 #goto DONE
       NEXT3D:
 end
 
#-----------------------------------------------------------------------------------------------
#-----------------------------------------------------------------------------------------------
 DONE:
 echo "----------------------------- END ------------------------------"
 exit 0     
            
 ERROR: 
    exit 1

