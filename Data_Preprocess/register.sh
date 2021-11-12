ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=48
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS

antsRegistration=/dfsdata2/houfeng1_data/yjw/packages/install/bin/antsRegistration
fix_path=/dfsdata2/houfeng1_data/yjw/MMchallenge/MMData/data_volume/
fixed_files="MM_C0S7W0-00_L_I_P_B_3 MM_C0S7W0-01_L_I_P_B_3 MM_C0S7W0-02_L_I_P_B_3 MM_C0S7W0-03_L_I_P_B_3 MM_C0S7W0-04_L_I_P_B_3 MM_C0S7W0-05_L_I_P_B_3 MM_C0S7W0-06_L_I_P_B_3 MM_C0S7W0-08_L_I_P_B_3 MM_C0S7W0-09_L_I_P_B_3 MM_C0S7W0-10_L_I_P_B_3 MM_C0S7W0-11_L_I_P_B_3 MM_C0S7W0-12_L_I_P_B_3 MM_C0S7W0-13_L_I_P_B_3 MM_C0S7W0-14_L_I_P_B_3 MM_C0S7W0-15_L_I_P_B_3 MM_C0S7W0-16_L_I_P_B_3 MM_C0S7W0-17_L_I_P_B_3 MM_C0S7W0-18_L_I_P_B_3 MM_C0S7W0-19_L_I_P_B_3 MM_C0S7W0-20_L_I_P_B_3 MM_C0S7W0-21_L_I_P_B_3 MM_C0S7W0-22_L_I_P_B_3 MM_C0S7W0-23_L_I_P_B_3"
moving_path=/dfsdata2/houfeng1_data/yjw/MMchallenge/MMData/data_volume/
moving_files="MM_C0S7W0-07_L_I_P_B_3 MM_C0S7W0-24_L_I_P_B_3"
save_path=/dfsdata2/houfeng1_data/yjw/MMchallenge/Reg_data/tmp/


for item in ${fixed_files}
do
  echo "fixed file: ${fix_path}${item}.nii.gz"
  for meti in ${moving_files}
  do
    echo "moving file: ${moving_path}${meti}.nii.gz"
    $antsRegistration --dimensionality 3 \
    --float 0 \
    --output [${save_path}${meti}_${item},${save_path}${meti}_${item}_warped.nii.gz] \
    --interpolation Linear \
    --use-histogram-matching 0 \
    --initial-moving-transform [${fix_path}${item}.nii.gz,${moving_path}${meti}.nii.gz,0] \
    --transform Rigid[0.2] \
    --metric MI[${fix_path}${item}.nii.gz,${moving_path}${meti}.nii.gz,1,32,Regular,0.25] \
    --convergence [1000x500x250x100,1e-6,10] \
    --shrink-factors 8x4x2x1 \
    --smoothing-sigmas 3x2x1x0vox \
    --transform Affine[0.2] \
    --metric MI[${fix_path}${item}.nii.gz,${moving_path}${meti}.nii.gz,1,32,Regular,0.25] \
    --convergence [1000x500x250x100,1e-6,10] \
    --shrink-factors 8x4x2x1 \
    --smoothing-sigmas 3x2x1x0vox \
    --transform SyN[0.2,3,0] \
    --metric MI[${fix_path}${item}.nii.gz,${moving_path}${meti}.nii.gz,1,32,Regular,0.25] \
    --convergence [100x70x50x20,1e-6,10] \
    --shrink-factors 8x4x2x1 \
    --smoothing-sigmas 3x2x1x0vox \
    --verbose 1
  done
done


antsApplyTransforms=/dfsdata2/houfeng1_data/yjw/packages/install/bin/antsApplyTransforms

moving_path=/dfsdata2/houfeng1_data/yjw/MMchallenge/MMData/seg_volume/
moving_files="MM_C0S7W0-07_L_I_P_B_3 MM_C0S7W0-24_L_I_P_B_3"
transform_path=/dfsdata2/houfeng1_data/yjw/MMchallenge/Reg_data/tmp/

fix_path=/dfsdata2/houfeng1_data/yjw/MMchallenge/MMData/data_volume/
fixed_files="MM_C0S7W0-00_L_I_P_B_3 MM_C0S7W0-01_L_I_P_B_3 MM_C0S7W0-02_L_I_P_B_3 MM_C0S7W0-03_L_I_P_B_3 MM_C0S7W0-04_L_I_P_B_3 MM_C0S7W0-05_L_I_P_B_3 MM_C0S7W0-06_L_I_P_B_3 MM_C0S7W0-08_L_I_P_B_3 MM_C0S7W0-09_L_I_P_B_3 MM_C0S7W0-10_L_I_P_B_3 MM_C0S7W0-11_L_I_P_B_3 MM_C0S7W0-12_L_I_P_B_3 MM_C0S7W0-13_L_I_P_B_3 MM_C0S7W0-14_L_I_P_B_3 MM_C0S7W0-15_L_I_P_B_3 MM_C0S7W0-16_L_I_P_B_3 MM_C0S7W0-17_L_I_P_B_3 MM_C0S7W0-18_L_I_P_B_3 MM_C0S7W0-19_L_I_P_B_3 MM_C0S7W0-20_L_I_P_B_3 MM_C0S7W0-21_L_I_P_B_3 MM_C0S7W0-22_L_I_P_B_3 MM_C0S7W0-23_L_I_P_B_3"
save_path=/dfsdata2/houfeng1_data/yjw/MMchallenge/Reg_data/tmp/


for item in ${fixed_files}
do
  for meti in ${moving_files}
  do
    echo ${moving_path}${meti}.nii.gz
    $antsApplyTransforms --dimensionality 3 \
    --input ${moving_path}${meti}.nii.gz \
    --reference-image ${fix_path}${item}.nii.gz \
    --output ${save_path}${meti}_${item}.nii.gz \
    --interpolation MultiLabel\
    --transform ${transform_path}${meti}_${item}1Warp.nii.gz \
    --transform ${transform_path}${meti}_${item}0GenericAffine.mat \
    --verbose 1
  done
done


antsJointFusion=/dfsdata2/houfeng1_data/yjw/packages/install/bin/antsJointFusion
atlas_path=/dfsdata2/houfeng1_data/yjw/MMchallenge/Reg_data/tmp/
atlas_label_path=/dfsdata2/houfeng1_data/yjw/MMchallenge/Reg_data/tmp/
atlas_files=("MM_C0S7W0-07_L_I_P_B_3" "MM_C0S7W0-24_L_I_P_B_3")

target_path=/dfsdata2/houfeng1_data/yjw/MMchallenge/MMData/data_volume/
target_files="MM_C0S7W0-00_L_I_P_B_3 MM_C0S7W0-01_L_I_P_B_3 MM_C0S7W0-02_L_I_P_B_3 MM_C0S7W0-03_L_I_P_B_3 MM_C0S7W0-04_L_I_P_B_3 MM_C0S7W0-05_L_I_P_B_3 MM_C0S7W0-06_L_I_P_B_3 MM_C0S7W0-08_L_I_P_B_3 MM_C0S7W0-09_L_I_P_B_3 MM_C0S7W0-10_L_I_P_B_3 MM_C0S7W0-11_L_I_P_B_3 MM_C0S7W0-12_L_I_P_B_3 MM_C0S7W0-13_L_I_P_B_3 MM_C0S7W0-14_L_I_P_B_3 MM_C0S7W0-15_L_I_P_B_3 MM_C0S7W0-16_L_I_P_B_3 MM_C0S7W0-17_L_I_P_B_3 MM_C0S7W0-18_L_I_P_B_3 MM_C0S7W0-19_L_I_P_B_3 MM_C0S7W0-20_L_I_P_B_3 MM_C0S7W0-21_L_I_P_B_3 MM_C0S7W0-22_L_I_P_B_3 MM_C0S7W0-23_L_I_P_B_3"
save_path=/dfsdata2/houfeng1_data/yjw/MMchallenge/MMData/new_labels/

for item in ${target_files}
do
  $antsJointFusion -d 3 \
  -o ${save_path}${item}.nii.gz \
  -t ${target_path}${item}.nii.gz \
  -g ${atlas_path}${atlas_files[0]}_${item}_warped.nii.gz \
  -l ${atlas_label_path}${atlas_files[0]}_${item}.nii.gz \
  -g ${atlas_path}${atlas_files[1]}_${item}_warped.nii.gz \
  -l ${atlas_label_path}${atlas_files[1]}_${item}.nii.gz \
  -v 1
done