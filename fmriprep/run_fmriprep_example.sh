#!/bin/bash

module load apptainer
module load fsl

SECONDS=0

# set singularity cache to a non HOME dir as it takes up a lot of space- SLATE home for now.
#export APPTAINER_CACHEDIR=CHANGE/THIS/TO/YOUR/SLATE/HOME
export APPTAINER_CACHEDIR=/N/slate/robfren/singcache

# reassign passed variables from driver loop for readability
subj=${1}

# freesurfer license
fslic=/N/soft/rhel7/freesurfer/6.0.0/freesurfer/license.txt

# set location for singularity img to use
#fmriprep_simg=/POINT/THIS/TO/YOUR/FMRIPREP/IMAGE
fmriprep_simg=/N/slate/robfren/example_bids_ds/code/container_images/fmriprep-25.1.3.simg

# input dir
#data_dir=/POINT/THIS/TO/YOUR/BIDS/DIRECTORY
data_dir=/N/slate/robfren/example_bids_ds

work_dir=/tmp/fmriprep_temp
s_work_dir=${work_dir}/${subj}/
mkdir -p $s_work_dir

# output here
#out_dir=/POINT/THIS/TO/YOUR/BIDS/DIRECORY AND THEN /derivatives/fmriprep
out_dir=/N/slate/robfren/example_bids_ds/derivatives/fmriprep_example
mkdir -p $out_dir

# tell fmriprep where templateflow lives
tp_dir=${HOME}/.cache/templateflow
export TEMPLATEFLOW_HOME=${tp_dir}
export APPTAINERENV_TEMPLATEFLOW_HOME=${tp_dir}  # Tell fMRIPrep the mount point
export SINGULARITYENV_TEMPLATEFLOW_HOME=${tp_dir}

apptainer run \
	-B ${data_dir}:/data/:ro \
	-B ${s_work_dir}:/work/ \
	-B ${out_dir}:/out/ \
	-B ${fslic}:/opt/freesurfer/license.txt \
	-B ${tp_dir}:/templateflow/ \
	--cleanenv ${fmriprep_simg} \
	--skip_bids_validation \
	--n_cpus $SLURM_CPUS_PER_TASK \
	--omp-nthreads $SLURM_CPUS_PER_TASK \
	--notrack \
	--md-only-boilerplate \
	--work-dir=/work/ \
	--fs-license-file=/opt/freesurfer/license.txt \
	--output-spaces MNI152NLin6Asym \
	--participant_label=${subj} \
	/data/ /out/ participant 

echo Finished ${subj}

echo Time elapsed in seconds: ${SECONDS} # print elaplsed time to end of job output file- useful for adjusting walltime


# testing container run the below command in the Terminal to ensu re the bindings (-B) are to the correct points
#apptainer shell \
#	-B ${data_dir}:/data/:ro \
#	-B ${s_work_dir}:/work/ \
#	-B ${out_dir}:/out/ \
#	-B ${fslic}:/opt/freesurfer/license.txt \
#	-B ${tp_dir}:/templateflow/ \
#	${fmriprep_simg}
