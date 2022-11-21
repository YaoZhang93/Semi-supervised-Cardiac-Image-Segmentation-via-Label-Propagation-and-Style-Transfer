#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Author: Yao Zhang
# Mail  : zhangyao215@mails.ucas.ac.cn

import os
import csv
import glob
import shutil
import numpy as np
import nibabel as nib
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
    regx = data_path+'*/*_sa.nii.gz'
    print('we are finding all data by regular expression {}'.format(regx))
    
    data_list = glob.glob(regx)
    data_list = np.sort(data_list)
    print('we found {} volumes'.format(len(data_list)))
    return data_list

        
def get_info(filename):
    info_dict = {}
    with open(filename) as f:
        f_csv = csv.reader(f)
        for row in f_csv:
            info_dict[row[1]] = [row[3], row[4]]
    
    return info_dict

    
def rename(data_path):
    # TODO override seg_filename
    data_filename = data_path.split('/')[-1]
    print('data filename: {}'.format(data_filename))
    
    # TODO override case_id
    case_id = data_filename.split('_')[0]
    print('case_id: {}'.format(case_id))
    
    # TODO make up the output data path
    # data new_filename = DATABASE-CASEID-ORIENTATION-SHAPE-INDEX-MODALITY
    # seg new_filename = DATABASE-CASEID-ORIENTATION-SHAPE-INDEX
    data_volume_nii = nib.load(data_path)
    data_volume = data_volume_nii.get_fdata().astype(np.float32)
    affine = data_volume_nii.affine
    
    # get info
    info_dict = get_info(info_filename)
    
    for i in range(data_volume.shape[-1]):
        case_sub_id = case_id + '-' + str(i).zfill(2)
        orientation = ','.join([str(x) for x in nib.aff2axcodes(affine)])
        vendor = info_dict[case_id][0]
        center = info_dict[case_id][1]
        modality = '0'.zfill(4)
    
        new_data_filename = 'MM_{}_{}_{}_{}_{}.nii.gz'.format(case_sub_id, orientation, vendor, center, modality)
        new_data_path = join(output_data_path, new_data_filename)
    
        print('saving {}'.format(new_data_filename))
        nib.save(nib.Nifti1Image(data_volume[..., i], affine), new_data_path)
        print('############ finish ############')

if __name__ == '__main__':
    input_path = '../ori_data/Unlabeled/'
    info_filename = '../ori_data/M&Ms.csv'
    
    output_data_path = '../ori_data/unlabeled_data_volume/'
    
    check_path(output_data_path)
    
    data_list = get_data_list(input_path)
    multiprocess_kernel = 16
    pool = Pool(multiprocess_kernel)
    pool.map(rename, data_list)
    pool.close()
    pool.join()
