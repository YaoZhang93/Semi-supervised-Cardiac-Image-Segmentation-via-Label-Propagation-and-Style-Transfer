# Semi-supervised-Cardiac-Image-Segmentation-via-Label-Propagation-and-Style-Transfer

## Paper

This is the official implementation of the paper:

[Semi-supervised-Cardiac-Image-Segmentation-via-Label-Propagation-and-Style-Transfer](https://arxiv.org/pdf/2012.14785.pdf),

which won the 2nd place in MICCAI 2020 Multi-Centre, Multi-Vendor &amp; Multi-Disease Cardiac Image Segmentation Challenge (M&amp;Ms)

![image](https://github.com/YaoZhang93/Semi-supervised-Cardiac-Image-Segmentation-via-Label-Propagation-and-Style-Transfer/blob/main/figs/framework.png)

![image](https://github.com/YaoZhang93/Semi-supervised-Cardiac-Image-Segmentation-via-Label-Propagation-and-Style-Transfer/blob/main/figs/reg.png)

## Result

![image](https://github.com/YaoZhang93/Semi-supervised-Cardiac-Image-Segmentation-via-Label-Propagation-and-Style-Transfer/blob/main/figs/results.png)

## Usage

`Please change the input and output paths before running the code!!!`

`Please change the input and output paths before running the code!!!`

`Please change the input and output paths before running the code!!!`

* Prepare data

  - Download the data from [MICCAI 2020 M&amp;Ms Challenge](https://www.ub.edu/mnms/).

  - Rename the data files. In `Data_Proprocess`, run `python rename.py` and `python rename_unlabeleddata.py`.

* Propagate the label to unlabelled volumes by registration. In `Data_Proprocess`, run `sh register.sh`.

* Train a preliminary model with both labelled and unlabelled data.

  - Preprocess the data referring to [the usage of nnUNet](https://github.com/MIC-DKFZ/nnUNet#how-to-run-nnu-net-on-a-new-dataset).

  - In `nnunet_semi_sup`, train the model by `python run/run_trainin.py 3d_fullres nnUNetTrainerV2 TASK_ID fold=all`.

* Transfer the style of data by histogram matching. In `Data_Proprocess`, run `python match_to_target_histogram.py`.

* Finetune the model with with both original and trasferred data.

  - Preprocess the data referring to [the usage of nnUNet](https://github.com/MIC-DKFZ/nnUNet#how-to-run-nnu-net-on-a-new-dataset).

  - Copy the preliminary model to the finetune model path.

  - In `nnunet_semi_sup`, finetune the model by `python run/run_trainin.py 3d_fullres nnUNetTrainerV2Finetune TASK_ID -f all -c`.

* inference on the test data by `python inference/predict_simple.py -i INPUT_PATH -o OUTPUT_PATH -t TASK_ID -f all -tr nnUNetTrainerV2Finetune`

## Citation

If you find this code and paper useful for your research, please kindly cite our paper.

```
@inproceedings{zhang2020semi,
  title={Semi-supervised Cardiac Image Segmentation via Label Propagation and Style Transfer},
  author={Zhang, Yao and Yang, Jiawei and Hou, Feng and Liu, Yang and Wang, Yixin and Tian, Jiang and Zhong, Cheng and Zhang, Yang and He, Zhiqiang},
  booktitle={International Workshop on Statistical Atlases and Computational Models of the Heart},
  pages={219--227},
  year={2020},
  organization={Springer}
}
```

## Acknowledgement

The implementation is based on the out-of-box [nnUNet](https://github.com/MIC-DKFZ/nnUNet).
