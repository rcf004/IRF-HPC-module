#!/bin/bash

curTime=`date +"%Y%m%d-%H%M%S"`     		# pull date for -o/-e logs
mkdir -p ./logs/${curTime}_slurmlogs	    # create logs directory

# AccID should be defined as a variable here
AccID=XXXXXX

# replace this with your IU email
UserEmail=[yourIUemailgoeshere]


FirstName=Roberto
LastName=French


sbatch \
    -A ${AccID} \
    --mail-user=${UserEmail} \
    --mail-type=FAIL \
    --mem=16G \
    --export=ALL \
    -o ./logs/${curTime}_slurmlogs/output_%j.txt \
    -e ./logs/${curTime}_slurmlogs/error_%j.txt \
    -J example_run \
	--time=0-00:10:00 \
	./example_job.sh \
	${FirstName} ${LastName}
    


