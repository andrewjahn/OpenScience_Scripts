#!/bin/bash
#Template provided by Daniel Levitas of Indiana University
#Edits by Andrew Jahn, University of Michigan, 07.22.2020

#User inputs:
bids_root_dir=$HOME/Desktop/Flanker
subj=08
nthreads=4
mem=20 #gb
container=docker #docker or singularity

#Begin:

#Convert virtual memory from gb to mb
mem=`echo "${mem//[!0-9]/}"` #remove gb at end
mem_mb=`echo $(((mem*1000)-5000))` #reduce some memory for buffer space during pre-processing

#export TEMPLATEFLOW_HOME=$HOME/.cache/templateflow
export FS_LICENSE=$HOME/Desktop/Flanker/derivatives/license.txt

#Run fmriprep
if [ $container == singularity ]; then
  unset PYTHONPATH; singularity run -B $HOME/.cache/templateflow:/opt/templateflow $HOME/fmriprep.simg \
    $bids_root_dir $bids_root_dir/derivatives \
    participant \
    --participant-label $subj \
    --skip-bids-validation \
    --md-only-boilerplate \
    --fs-license-file $HOME/Desktop/Flanker/derivatives/license.txt \
    --fs-no-reconall \
    --output-spaces MNI152NLin2009cAsym:res-2 \
    --nthreads $nthreads \
    --stop-on-first-crash \
    --mem_mb $mem_mb \
else
  fmriprep-docker $bids_root_dir $bids_root_dir/derivatives \
    participant \
    --participant-label $subj \
    --skip-bids-validation \
    --md-only-boilerplate \
    --fs-license-file $HOME/Desktop/Flanker/derivatives/license.txt \
    --fs-no-reconall \
    --output-spaces MNI152NLin2009cAsym:res-2 \
    --nthreads $nthreads \
    --stop-on-first-crash \
    --mem_mb $mem_mb
fi
