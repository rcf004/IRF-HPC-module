#!/bin/bash

curTime=`date +"%Y%m%d-%H%M%S"`     		# pull date for -o/-e logs
mkdir -p ./logs/${curTime}_slurmlogs/output     # create logs directory
mkdir -p ./logs/${curTime}_slurmlogs/error


# AccID should be defined as a variable here
AccID=XXXXXX

# replace this with your IU email
UserEmail=[yourIUemailgoeshere]


filelist=./cast_dpk_sublist_fmriprep.tsv

# pull first and second column from tsv
subjid=($(awk -F '\t' '{print $1}' ${filelist} | awk 'NR!=1 {print}'))

for subj in ${subjid[@]}; do 
	
	sbatch \
		-A ${AccID} \
		--mail-user=${UserEmail} \
		--mail-type=FAIL \
		--nodes=1 \
		--mem=64G \
		--tasks-per-node=1 \
		--cpus-per-task=8 \
		-o ./logs/${curTime}_slurmlogs/output/output_sub-${subj}.txt \
		-e ./logs/${curTime}_slurmlogs/error/error_sub-${subj}.txt \
		-J fmriprep_sub-${subj} \
		--time=1-00:00:00 \
		./run_fmriprep_example.sh \
		${subj} \
		|| continue
	
	sleep 2

done


