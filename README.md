# bl_app_dbb_preprocessing_t1w

This application performs a basic pre-processing of t1-w images:

1. ACPC alignment
2. Bias Field Correction

### Authors

    Gabriele Amorosino (gamorosino@fbk.eu)
    Matteo Ballabio (matteoballabio99@gmail.com)
    Paolo Avesani (avesani@fbk.eu)

### Project directors

    Gabriele Amorosino (gamorosino@fbk.eu)
    Matteo Ballabio (matteoballabio99@gmail.com)
    Paolo Avesani (avesani@fbk.eu)


## Running the App

### Input 

There are two mandatory inputs:
    
	-i, --input         T1-w image to be preprocessed    
	-t, --template      template as reference space to be reoriented (e.g. MNI152)
   
and some optional inputs:

	-o, --outputdir     if not provided, the scripts creates the folder *T1w_preproc* in the same folder as the input image
	-a, --affine        fullpath of affine matrix to perform rigid transformation to the template
	-m, --mask          full path of the brain mask to limit Bias-field correction on these voxels     
	-n, --nthreads      number of threads

### On Brainlife.io

You can see DBB_preprocessing_t1w currently regsitered on Brainlife. Find the App that you'd like to run and click "Execute" tab to specify dataset "DBB Malformation Brain Benchmark".

### Dependecies

This App runs on singularity.

### Outputs

The outputs of bl_app_dbb_preprocessing_t1w are:
     
     -a T1-w rigidly reoriented to template space. The file has the same *basename* of the input T1-w file with the suffix *_reoriented*
     -a T1-w rigidly reoriented to template space and with Bias Field Corrected. The file has the same *basename* of the input T1-w file with the suffix *_reoriented_N4*


