#!/bin/bash

SECONDS=0 # init internal SECONDS variable to get time for this job

ml conda
conda activate dcm2bids_env
# reassign passed variables from driver loop for readability
subjid=$1  
subjdir=$2

# this should be edited to your BIDS directory
dicomroot=/N/slate/robfren/example_bids_ds/sourcedata
outputdir=/N/slate/robfren/example_bids_ds/

echo running subject ${subjid} 

dcm2bids \
	-d ${dicomroot}/${subjdir} \
	-p ${subjid} \
	-c ./cast_dpk_config.json \
	-o ${outputdir} \
	--force_dcm2bids --clobber \


echo "Time elapsed in seconds: ${SECONDS}" # print elaplsed time to end of job output file- useful for adjusting walltime


