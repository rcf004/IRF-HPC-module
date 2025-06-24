#!/bin/bash
# written by Roberto French

# wrap auto move dicom script with zenity UI for ease of interface

# default pattern for grep - alter this in script if you want to have something show up by default
pattern='Input_Pattern_Here'

# initial zenity window to type in pattern for regex
pattern=$(zenity --title "Copy dicoms" --entry --text "Copy dicoms using regex pattern specified below:" --entry-text ${pattern})
# cancel exits
[[ "$?" != "0" ]] && exit 1

# default entries for output location and IRF location
outdir="~"
IRF_dir="/N/project/IRF"

# select output location
outdir=$(zenity --file-selection --title="Choose output destination" --directory --filename=${outdir})
# cancel exits
[[ "$?" != "0" ]] && exit 1

# select IRF/source location
IRF_dir=$(zenity --file-selection --title="Choose IRF/source location" --directory --filename=${IRF_dir})
# cancel exits
[[ "$?" != "0" ]] && exit 1

# list subjects in output folder
cursubs=($(ls $outdir | egrep -i ${pattern})) 
# get subjects in IRF folder
IRF=($(ls $IRF_dir | egrep -i ${pattern}))

# find difference of arrays
dif=(`echo ${cursubs[@]} ${IRF[@]} | tr ' ' '\n' | sort | uniq -u`)

# make a nicely printed version of subjects found
printf -v clean '%s\n\t' "${dif[@]}"

# append these to a text file with date stamp
dt=$(date '+%Y-%m-%dT%T.%zZ')
echo "------- ${dt} -------" >> copied_dicoms.txt
printf "%s\n" ${dif[@]} >> copied_dicoms.txt

# zenity wrapper for the move script
if zenity --question \
          --title="Confirm information is correct" \
          --text="output directory: ${outdir}\nIRF directory: ${IRF_dir}\nSubjects:\n\t${clean}"; then
    
        # main loop that moves subjects
        ( for sub in $(seq 0 $((${#dif[@]}-1))); do
                # controlls fill of progress bar
                echo $((100/${#dif[@]}*(${sub}))) 
                # # prefix writes to the window
                echo "#copying subject: ${dif[$sub]} ..."
                # actual command
                cp -R ${IRF_dir}/${dif[$sub]} $outdir
                

        done ) |
        zenity --progress \
               --title="Copying Dicoms" \
               --percentage=0 \
               --auto-close

        # final window to show what was moved
        zenity --info --title="Finished" --text="Subjects:\n\n\t${clean}\n Have been copied, double check for missing subjects"        
        
        # cancel kills window
        if [ "$?" = -1 ] ; then
                zenity --error --text="Cancelled."
        fi

else
        # cancel kills window
        zenity --error --text="Cancelled."

fi


