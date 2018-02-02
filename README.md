######       WRF_CCRN_note      ######   
the note for running WRF for the CCRN domain and data README
Created: Zhe Zhang 20171113
Updated: Zhe Zhang 20180201

###### Special Thanks to Kyoko Ikeda, Liang Chen, Sopan Kurkute, who have created and contributed to the codes.

###### WRF CCRN WEST CANADA 4KM ######
PURPOSE:
The purpose of this readme file is to keep record of and manage
of the WRF data stored on Compute Canada Graham computer

######
LOG:
Please type in the log in this format:
01234567890123456789012345678901234567890123456789
 DATE    | JOB               | WHO     | BRIEF
YYYYMMDD | NAME              | INITIAL | DESCRIPTION
e.g.     |                   |         |
20171113 | UPDATE COMPLETE   | Z.Z.    | RERUN DATA UPDATED ON GRAHAM PROJECT DIRECTORY
20180201 | UPDATE COMPLETE   | Z.Z.    | UPDATA CTRL AND PGW FROM 20130901 TO 20150930

######
DESCRIPTION:
20171113 update:
1. Rerun data are for three separate periods: CTL 200010-200212; PGW 200010-200302; PGW 200801-201311;
2. Two new_2015 data are for Julie's group to evaluate their site campign in Alberta;
3. Data stored: new_YYYY_1HR_2D data are hourly surface field data extracted and generated directly from WRF simulation (NO POST-PROCESS); new_YYYY_3HR_2D_3D data are 3hourly surface and upper atmosphere data separated from the original WRF output - wrfout (POST-PROCESS);
4. For 2013 PGW especially, in new_2013_1HR_2D, the data goes to 2013 Nov 29;

20180201 update:
1. Run data from 20130901 to 20150930 for both CTRL and PGW; They are named in different folder new_2013_1HR_2D_2018 & new_2013_3HR_3D_2018;
2. In 2D folders, the wrf2d files don't contain variables: I_RAINNC, but PRCP_ACC_NC, this is the hourly output three hourly accumulated precipitation. Thus, is useful for calculating 3-hourly/daily/monthly precipitation, except hourly; This is an artificial mistake by Zhe Zhang without including "I_RAINNC" in the extraoutput.txt when running the simulation; May be fixed in later use. But is OK for hydrology modeling.
