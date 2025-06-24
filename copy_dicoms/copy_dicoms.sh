#!/bin/bash

# written by Roberto French

# variable defining destination directory for where raw data scans should be copied to
outdir="SPECIFY THIS DIRECTORY"

# define an array of subjects in destination folder, so we don't redundantly copy old subjects 
# change this regex pattern to match your study name/PI name to match only your scans.
cursubs=($(ls $outdir | egrep -i SPECIFY_REGEX_PATTERN)) 

# get subjects in IRF folder
IRF=($(ls /N/project/IRF | egrep -i SPECIFY_REGEX_PATTERN))

# find difference of arrays, only keep new subjects
dif=(`echo ${cursubs[@]} ${IRF[@]} | tr ' ' '\n' | sort | uniq -u`)

# copy just those subjects
for sub in $(seq 0 $((${#dif[@]}-1))); do

        echo copying subject ${dif[$sub]}
        cp -R /N/project/IRF/${dif[$sub]} $outdir

done

