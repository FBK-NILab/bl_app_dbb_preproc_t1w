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

### Input MBB

There are two mandatory inputs:
    
	-i, --input         T1-w image to be preprocessed    
	-t, --template      template as reference space to be reoriented
   
and some optional inputs:

	-o, --outputdir     if not provided, the scripts create the folder 
	-a, --affine        affine matrix to perform rigid transformation to the template
	-m, --mask          brain mask to limit Bias-field correction on these voxels     
	-n, --nthreads      number of threads

### On Brainlife.io

You can see app-MBB_preprocessing_t1w currently regsitered on Brainlife. Find the App that you'd like to run and click "Execute" tab to specify dataset "MBB Malformation Brain Benchmark".

### Dependecies

This App runs on singularity.

### Output MBB

The results of app-MBB_preprocessing_t1w are:
     
     -T1-w reoriented.nii.gz
     -T1-w reoriented_N4BiasField.nii.gz


