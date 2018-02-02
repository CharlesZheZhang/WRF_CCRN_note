#!/bin/csh
# submit batch jobs for globus transfer 
# Zhe Zhang
# Feb 1 2018

# need to know the endpoint id 
# can check with  globus endpoint search 'xxxx'
# these are the endpoints for cheyenne (cy) and graham (gh)
set cy_ep = "d33b3614-6d04-11e5-ba46-22000b92c6ec"
set gh_ep = "499930f1-5c43-11e7-bf29-22000b9a448b"

# submit globus transfer command by adding the path at the end of the endpoint
# use option --recursive for all files and directories within the path
# use option --label for future reference

set EXP  = CTRL/PGW 
set YYYY = YYYY
set MMs  = ( 01 02 03 04 05 06 07 08 09 10 11 12 )
set dir_src = ""
set dir_dst = ""

# make a new folder in dir_dst
globus mkdir ${gh_ep}:${dir_src}${EXP}/${YYYY}_3HR_2D_3D/

foreach MM ( ${MMs} )
        globus transfer ${cy_ep}:${dir_src} ${gh_ep}:${dir_dst} --recursive --label=${EXP}${YYYY}${MM}
end 
