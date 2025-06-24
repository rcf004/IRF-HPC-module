#!/bin/bash

ml conda
conda activate dcm2bids_env

filelist=./cast_dpk_sublist.tsv

# pull first and second column from tsv
subjid=($(awk -F '\t' '{print $1}' ${filelist} | awk 'NR!=1 {print}'))
subjdir=($(awk -F '\t' '{print $2}' ${filelist} | awk 'NR!=1 {print}'))

# input and output
# this should be edited to your BIDS directory
dicomroot=/N/slate/robfren/example_bids_ds/sourcedata
outputdir=/N/slate/robfren/example_bids_ds/

# get length of list, min 1 due to 0 based index
END=$((${#subjid[@]}-1))

for ind in $(seq 0 $END); do 

	echo running subject ${subjid[${ind}]} 

	dcm2bids \
		-d ${dicomroot}/${subjdir[${ind}]} \
		-p ${subjid[${ind}]} \
		-c ./cast_dpk_config.json \
		-o ${outputdir} \
		--force_dcm2bids --clobber \
		|| continue

done

