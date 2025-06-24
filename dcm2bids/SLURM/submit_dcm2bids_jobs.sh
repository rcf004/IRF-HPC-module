#!/bin/bash

curTime=`date +"%Y%m%d-%H%M%S"`     			# pull date for -o/-e logs
mkdir -p ./logs/${curTime}_slurmlogs/output     # create logs directory
mkdir -p ./logs/${curTime}_slurmlogs/error


# AccID should be defined as a variable here
#AccID=XXXXXX
AccID=r00223

# replace this with your IU email
#UserEmail=[yourIUemailgoeshere]
UserEmail=robfren@iu.edu


filelist=./cast_dpk_sublist.tsv

# pull first and second column from tsv
subjid=($(awk -F '\t' '{print $1}' ${filelist} | awk 'NR!=1 {print}'))
subjdir=($(awk -F '\t' '{print $2}' ${filelist} | awk 'NR!=1 {print}'))


# get length of list, min 1 due to 0 based index
END=$((${#subjid[@]}-1))

for ind in $(seq 0 $END); do 
	
	sbatch \
		-A ${AccID} \
		--mail-user=${UserEmail} \
		--mail-type=FAIL \
		--mem=16G \
		--export=ALL \
		-o ./logs/${curTime}_slurmlogs/output/output_${subjid[${ind}]}.txt \
		-e ./logs/${curTime}_slurmlogs/error/error_${subjid[${ind}]}.txt \
		-J dcm2bids_${subjid[${ind}]}  \
		--time=0-01:00:00 \
		./run_dcm2bids.sh \
		${subjid[${ind}]} ${subjdir[${ind}]} \
		|| continue

	sleep 2

done

