#!/bin/bash

#This script assumes you have already run the file make_Timings.sh, as explained in this chapter: https://andysbrainbook.readthedocs.io/en/latest/OpenScience/OS/fMRIPrep_Demo_5_1stLevelAnalysis.html
#This is combined code from the OpenScience module of Andy's Brain Book: https://andysbrainbook.readthedocs.io/en/latest/OpenScience/OS/fMRIPrep_Demo.html


for i in `cat subjList.txt`; do
      cd code;
      bash fmriprep_Scripted.sh $i;
      cd ../derivatives/fmriprep/${i}/func
      for run in 1 2; do
        3dmerge -1blur_fwhm 4.0 -doall -prefix r${run}_blur.nii \
            ${i}_task-flanker_run-${run}_space-MNI152NLin2009cAsym_res-2_desc-preproc_bold.nii.gz;
        done
      for run in 1 2; do
        3dTstat -prefix rm.mean_r${run}.nii r${run}_blur.nii;
        3dcalc -a r${run}_blur.nii -b rm.mean_r${run}.nii \
           -c ${i}_task-flanker_run-${run}_space-MNI152NLin2009cAsym_res-2_desc-brain_mask.nii.gz                            \
           -expr 'c * min(200, a/b*100)*step(a)*step(b)'       \
           -prefix r${run}_scale.nii;
        done
        rm rm*;
        3dmask_tool -inputs *mask.nii.gz -union -prefix full_mask.nii
      mkdir stimuli;
      cp ../../../../${i}/func/*.1D stimuli;
      cp ../../../../doDecon.sh .;
      for reg in trans_x trans_y trans_z rot_x rot_y rot_z; do
        for run in 1 2; do
         awk -v col=$reg 'NR==1{for(i=1;i<=NF;i++){if($i==col){c=i;break}} print $c} NR>1{print $c}' ${i}_task-flanker_run-${run}_desc-confounds_regressors.tsv > ${reg}_run${run}_all_tmp.txt;
         sed '1d' ${reg}_run${run}_all_tmp.txt > ${reg}_run${run}_noHead_tmp.txt
         sed '1!d' ${reg}_run${run}_all_tmp.txt > ${reg}_run${run}_Head_tmp.txt
        done
      done
      NT=`3dinfo -nt r1_scale.nii`
      if [ -f zeros_tmp.txt ]; then rm zeros_tmp.txt; fi
      for ((j=0; j<$NT; j++)); do echo 0 >> zeros_tmp.txt; done
      for reg in trans_x trans_y trans_z rot_x rot_y rot_z; do
        for run in 1 2; do
          if [ $run -eq 1 ]; then
            cat ${reg}_run${run}_noHead_tmp.txt > ${reg}_run${run}.txt
          else
            cat zeros_tmp.txt ${reg}_run${run}_noHead_tmp.txt > ${reg}_run${run}.txt
          fi
        done
      done
      rm *tmp*
      tcsh doDecon.sh $i
      cd ../../../..
done
