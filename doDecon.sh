#!/bin/tcsh
# For the fMRIPrep tutorial, copy and paste this into the "func" directory of ${subj} in the "derivatives/fmriprep" folder
# and type: "tcsh doDecon.sh ${subj}"

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
    -stim_file 3 trans_x_run1.txt'[0]' -stim_base 3 -stim_label 3 trans_x_01   \
    -stim_file 4 trans_y_run1.txt'[0]' -stim_base 4 -stim_label 4 trans_y_01  \
    -stim_file 5 trans_z_run1.txt'[0]' -stim_base 5 -stim_label 5 trans_z_01    \
    -stim_file 6 rot_x_run1.txt'[0]' -stim_base 6 -stim_label 6 rot_x_01     \
    -stim_file 7 rot_y_run1.txt'[0]' -stim_base 7 -stim_label 7 rot_y_01     \
    -stim_file 8 rot_z_run1.txt'[0]' -stim_base 8 -stim_label 8 rot_z_01     \
    -stim_file 9 trans_x_run2.txt'[0]' -stim_base 9 -stim_label 9 trans_x_02   \
    -stim_file 10 trans_y_run2.txt'[0]' -stim_base 10 -stim_label 10 trans_y_02    \
    -stim_file 11 trans_z_run2.txt'[0]' -stim_base 11 -stim_label 11 trans_z_02 \
    -stim_file 12 rot_x_run2.txt'[0]' -stim_base 12 -stim_label 12 rot_x_02  \
    -stim_file 13 rot_y_run2.txt'[0]' -stim_base 13 -stim_label 13 rot_y_02  \
    -stim_file 14 rot_z_run2.txt'[0]' -stim_base 14 -stim_label 14 rot_z_02  \
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
