# bl_app_dbb_preprocessing_t1w

This application performs a basic pre-processing of t1-w images:

1. ACPC alignment
2. Bias Field Correction

### Authors

    Gabriele Amorosino (gamorosino@fbk.eu)
    Matteo Ballabio (matteoballabio99@gmail.com)
    Paolo Avesani (avesani@fbk.eu)

## Running the Brainlife App


You can run the BrainLife App `DBB_preprocessing_t1w` on the brainlife.io platform via the web user interface (UI) or using the `brainlife CLI`.  With both of these two solutions, the inputs and outputs are stored on the brainlife.io platform, under the specified project and the computations are performed using the brainlife.io cloud computing resources.


### On Brainlife.io via UI

You can see DBB_preprocessing_t1w currently regsitered on Brainlife. Find the App on _brainlife.io_ and click "Execute" tab and specify dataset e.g. "DBB Malformation Brain Benchmark".

### On Brainlife.io using CLI

Brainlife CLI could be installed on UNIX/Linux-based system following the instruction reported in https://brainlife.io/docs/cli/install/.

you can run the App with CLI as follow:
```
bl app run --id  60cb69e0cdfdb50220fee1c3--project <project_id> --input t1:<t1_object_id> \
--input mask:<mask_object_id> --input affine:<affine_object_id>
```
the output is stored in the reference project specified with the id ```<project_id>```. You can retrive the _object_id_ using the command ```bl data query```, e.g do get the id of the mask file for the subject _0001_ :
```
bl data query --subject 0001 --datatype neuro/mask --project <projectid>
```

If not present yet, you can upload a new file in a project using ```bl data upload```. For example, in the case of T1-w file, for the subject 0001 you can run:
```
bl data upload --project <project_id> --subject 0001 --datatype "neuro/anat/t1w" --t1 <full_path>

```
## Running the code locally

You can run the code on your local machine by git cloning this repository. You can chose to run it with _dockers_, avoiding to install any software except for [singularity](https://sylabs.io/). Furthermore you can run the original script using local softwares installed.

### Run the script using the dockers (recommended)

It is possible to run the app locally, using the dockers that embedded all needed softawers. This is exactly the same way that apps run code on brainlife.io

Inside the cloned directory, create `config.json` with something like the following content with the fullpaths to your local input files:
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

Clone this repository using git on your local machine to run this script.

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
	
Example:

T1Wbasicpreproc.sh -i ./t1.nii.gz -t ./data/MNI152_T1_1mm.nii.gz -m ./mask.nii.gz -a ./affine.txt

```
In the repositopry is present the folder _data/_ where is stored a reference template in MNI space (MNI152) at the resolution of 1mm (isotrtopic).

#### Output

The output of bl_app_dbb_preprocessing_t1w is the preprocessed T1-w i.e. rigidly reoriented to template space and with Bias Field Corrected         

The file is stored in the `--outputdir` folder and has the same *basename* of the input T1-w file with the suffix "_reoriented_N4"

####  Script Dependecies

In order to use the scritp, the following software must be installed:
ANTs, Advanced Normalization Tools (version >= 2.1.0)
