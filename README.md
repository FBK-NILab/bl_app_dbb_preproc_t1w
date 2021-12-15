# bl_app_dbb_preprocessing_t1w

This application performs a basic pre-processing of t1-w images:

1. ACPC alignment
2. Bias Field Correction

### Authors

    Gabriele Amorosino (gamorosino@fbk.eu)
    Matteo Ballabio (matteoballabio99@gmail.com)
    Paolo Avesani (avesani@fbk.eu)

## Running the Brainlife App




### On Brainlife.io via UI

You can see DBB_preprocessing_t1w currently regsitered on Brainlife. Find the App on _brainlife.io_ to run and click "Execute" tab to specify dataset "DBB Malformation Brain Benchmark".

## Running the code locally

You can run the code on your local machine by git cloning this repository. You can chose to run it with _dockers_, avoiding to install any software except for [singularity](https://sylabs.io/). Furthermore you can run the original script using local softwares installed.

### Run the script using the dockers

It is possible to run the app locally, using the dockers that embedded all needed softawers. This is exactly the same way that apps run code on brainlife.io

Inside the cloned directory, create `config.json` with something like the following content with paths to your input files:
```
{   
    "t1": "./t1.nii.gz",
    "mask": "./mask.nii.gz"
    "affine": "./affine.txt",
}
```

Launch the App by executing `main`.
```
./main
```
#### Script Dependecies

The App needs   `singularity` to run.

#### Output

The output of bl_app_dbb_preprocessing_t1w is the preprocessed T1-w i.e. rigidly reoriented to template space and  bias-field corrected         

The file is stored in the working directory, under the folder _./outoputdir_ and has the same *basename* of the input T1-w file with the suffix "_reoriented_N4"

*n.b.* You can find a copy of the same file, stored in the working directory under the folder _./T1_reoriented_N4_ with the standard brainlife.io name _t1.nii.gz_


### Run the script (local softwares) 

### Usage

The tool can be used through the `T1Wbasicpreproc.sh` script.

```
T1Wbasicpreproc.sh -i <T1.ext> -t <template.ext> [-o <outputdir>] [-a <affine.ext>] [-m <mask.ext>] [-n <num>]

There are two mandatory inputs:
    
	-i, --input         T1-w image to be preprocessed    
	-t, --template      template as reference space to be reoriented (e.g. MNI152)
   
and some optional inputs:

	-o, --outputdir     if not provided, the scripts creates the folder "T1w_preproc" in the same folder 
	                    as the input image
	-a, --affine        fullpath of affine matrix to perform rigid transformation to the template
	-m, --mask          full path of the brain mask to limit Bias-field correction on these voxels     
	-n, --nthreads      number of threads
```

#### Output

The output of bl_app_dbb_preprocessing_t1w is the preprocessed T1-w i.e. rigidly reoriented to template space and with Bias Field Corrected         

The file is stored in the `--outputdir` folder and has the same *basename* of the input T1-w file with the suffix "_reoriented_N4"

####  Script Dependecies

In order to use the scritp, the following software must be installed:
ANTs, Advanced Normalization Tools (version >= 2.1.0)
