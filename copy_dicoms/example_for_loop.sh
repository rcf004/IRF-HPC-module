#!/bin/bash

IRFscans=($(ls /N/project/IRF | egrep -i Cast_dpk.*@dpk))

for scan in ${IRFscans[@]}
do
   echo copying $scan
   cp -r /N/project/IRF/${scan} /N/slate/robfren/example_scan_directory
done


