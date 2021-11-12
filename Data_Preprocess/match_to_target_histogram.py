#!/usr/bin/env python
# coding=utf-8
# Author: Yao
# Mail: zhangyao215@mails.ucas.ac.cn


import os
import glob
import shutil
import numpy as np
import nibabel as nib
from skimage.transform import resize
from skimage.exposure import match_histograms
from multiprocessing import Pool
join = os.path.join


def check_path(file_path, overwrite=True):
    if os.path.exists(file_path):
        if overwrite:
            shutil.rmtree(file_path)
            os.makedirs(file_path)
    else:
        os.makedirs(file_path)


def get_data_list(data_path):
    # TODO override regx
    regx = data_path + '*.nii.gz'
    print('we are finding all data by regular expression {}'.format(regx))
    
    data_list = glob.glob(regx)
    data_list = np.sort(data_list)
    print('we found {} volumes'.format(len(data_list)))
    return data_list


def match_vendor(data_path):
    data_filename = data_path.split('/')[-1]
    seg_filename = data_filename.replace('_' + data_filename.split('_')[-1], '.nii.gz')
    print('data filename: {}'.format(data_filename))
    print('seg filename: {}'.format(seg_filename))
    
    data_volume_nii = nib.load(data_path)
    data_volume = data_volume_nii.get_fdata()
    affine = data_volume_nii.affine
    
    print(data_volume.shape, template.shape)
    matched_volume = match_histograms(data_volume, template, multichannel=False)
    
    source_vendor = data_filename.split('_')[3]
    data_filename = data_filename.replace('_'+source_vendor+'_', '_'+source_vendor+target_vendor+'_')
    print('saving {}'.format(data_filename))
    nib.save(nib.Nifti1Image(matched_volume, affine), join(output_data_path, data_filename))
    
    seg_path = join(input_seg_path, seg_filename)
    if os.path.isfile(seg_path):
        seg_filename = seg_filename.replace('_'+source_vendor+'_', '_'+source_vendor+target_vendor+'_')
        print('saving {}'.format(seg_filename))
        shutil.copy(seg_path, join(output_seg_path, seg_filename))
    print('############ finish ############')
    

def get_template():
    template_file = './template_' + target_vendor + '.nii.gz'
    # template_file = './template_roi_' + target_vendor + '.nii.gz'
    if os.path.isfile(template_file):
        template = nib.load(template_file).get_fdata()
    else:
        if target_vendor == 'F':
            template_candidates = glob.glob(join(input_data_path, '*.nii.gz'))
        else:
            template_candidates = glob.glob(join(input_data_path, '*_'+target_vendor+'_*.nii.gz'))

        affine = nib.load(template_candidates[0]).affine

        ################# get target region
        for i in range(len(template_candidates)):
            data_volume = nib.load(template_candidates[i]).get_fdata()
            seg_volume = nib.load(template_candidates[i].replace(input_data_path, input_seg_path).replace('_0000.nii.gz', '.nii.gz')).get_fdata()
            
            # region_ind = np.where(seg_volume > 0)
            # x_min = np.min(region_ind[0])
            # x_max = np.max(region_ind[0])
            # y_min = np.min(region_ind[1])
            # y_max = np.max(region_ind[1])
            # z_min = np.min(region_ind[2])
            # z_max = np.max(region_ind[2])
            # template_candidates[i] = data_volume[x_min:x_max+1, y_min:y_max+1, z_min:z_max+1]
            template_candidates[i] = data_volume
        ################# get target region
        
        sampled_candidates = []
        # shape = nib.load(template_candidates[0]).get_fdata().shape
        shape = template_candidates[0].shape
        for i in range(100):
            random_ind = np.random.randint(len(template_candidates))
            # sampled_candidates.append(resize(nib.load(template_candidates[random_ind]).get_fdata(), shape, order=3, mode='constant', cval=0, clip=True, preserve_range=True))
            sampled_candidates.append(resize(template_candidates[random_ind], shape, order=3, mode='constant', cval=0, clip=True, preserve_range=True))
        
        template = np.mean(sampled_candidates, axis=0)
        
        nib.save(nib.Nifti1Image(template, affine), template_file)
        
    return template
    
if __name__ == '__main__':
    input_data_path = '../crop_data/data_volume/'
    input_seg_path = '../crop_data/seg_volume/'
    
    output_data_path = '../crop_data/match_data_volume/'
    output_seg_path = '../crop_data/match_seg_volume/'
    
    check_path(output_data_path, overwrite=False)
    check_path(output_seg_path, overwrite=False)
    
    # source_vendor = 'B'
    target_vendor = 'A'
    
    template = get_template()
    
    data_list = get_data_list(input_data_path)
    multiprocess_kernel = 16
    pool = Pool(multiprocess_kernel)
    pool.map(match_vendor, data_list)
    pool.close()
    pool.join()
