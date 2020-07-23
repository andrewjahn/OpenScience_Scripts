#!/bin/tcsh
# For the fMRIPrep tutorial, copy and paste this into the "func" directory of sub-08 in the "derivatives/fmriprep" folder
# and type: "tcsh doDecon.sh sub-08"

if ( $#argv > 0 ) then
    set subj = $argv[1]
else
    set subj = s01
endif

3dDeconvolve -input r*_scale.nii                            \
#    -censor motion_${subj}_censor.1D                                         \
    -mask full_mask.nii						     \
    -polort 2                                                                \
    -num_stimts 14                                                           \
    -stim_times 1 stimuli/congruent.1D 'BLOCK(2,1)'                          \
    -stim_label 1 congruent                                                  \
    -stim_times 2 stimuli/incongruent.1D 'BLOCK(2,1)'                        \
    -stim_label 2 incongruent                                                \
    -stim_file 3 sub-08_task-flanker_run-1_desc-confounds_regressors.tsv'[150]' -stim_base 3 -stim_label 3 roll_01   \
    -stim_file 4 sub-08_task-flanker_run-1_desc-confounds_regressors.tsv'[154]' -stim_base 4 -stim_label 4 pitch_01  \
    -stim_file 5 sub-08_task-flanker_run-1_desc-confounds_regressors.tsv'[158]' -stim_base 5 -stim_label 5 yaw_01    \
    -stim_file 6 sub-08_task-flanker_run-1_desc-confounds_regressors.tsv'[162]' -stim_base 6 -stim_label 6 dS_01     \
    -stim_file 7 sub-08_task-flanker_run-1_desc-confounds_regressors.tsv'[166]' -stim_base 7 -stim_label 7 dL_01     \
    -stim_file 8 sub-08_task-flanker_run-1_desc-confounds_regressors.tsv'[170]' -stim_base 8 -stim_label 8 dP_01     \
    -stim_file 9 sub-08_task-flanker_run-2_desc-confounds_regressors.tsv'[150]' -stim_base 9 -stim_label 9 roll_02   \
    -stim_file 10 sub-08_task-flanker_run-2_desc-confounds_regressors.tsv'[154]' -stim_base 10 -stim_label 10        \
    pitch_02                                                                 \
    -stim_file 11 sub-08_task-flanker_run-2_desc-confounds_regressors.tsv'[158]' -stim_base 11 -stim_label 11 yaw_02 \
    -stim_file 12 sub-08_task-flanker_run-2_desc-confounds_regressors.tsv'[162]' -stim_base 12 -stim_label 12 dS_02  \
    -stim_file 13 sub-08_task-flanker_run-2_desc-confounds_regressors.tsv'[166]' -stim_base 13 -stim_label 13 dL_02  \
    -stim_file 14 sub-08_task-flanker_run-2_desc-confounds_regressors.tsv'[170]' -stim_base 14 -stim_label 14 dP_02  \
    -jobs 8                                                                  \
    -gltsym 'SYM: incongruent -congruent'				     \
    -glt_label 1 incongruent-congruent					     \
    -gltsym 'SYM: congruent -incongruent'				     \
    -glt_label 2 congruent-incongruent					     \
    -fout -tout -x1D X.xmat.1D -xjpeg X.jpg                                  \
    -x1D_uncensored X.nocensor.xmat.1D                                       \
    -fitts fitts.$subj                                                       \
    -errts errts.${subj}                                                     \
    -bucket stats.$subj
