<h1 align="center">DBB_preprocessing_t1w</h1>

<p align="center">
  Reorients a T1-weighted image to MNI152 (AC-PC) with a given or ANTs-estimated rigid transform and corrects its bias field with N4, as preprocessing for the Distorted Brain Benchmark.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.535"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.535-blue.svg" alt="Run on brainlife.io"></a>
</p>

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Reorients a T1-weighted image to MNI152 (AC-PC) with a given or ANTs-estimated rigid transform and corrects its bias field with N4, as preprocessing for the Distorted Brain Benchmark.**

Applies the given reorientation matrix (or a rigid ANTs registration to the MNI152 1 mm template when none is given) to the T1w and the brain mask, then runs N4 bias field correction restricted to the mask. Use it to prepare T1w images, including paediatric and distorted brains, for tissue segmentation as in the DBB benchmark.

| | |
|---|---|
| **Inputs** | `neuro/anat/t1w` · `neuro/mask` · `neuro/transform/nifti` |
| **Outputs** | `neuro/anat/t1w` · `neuro/mask` |
| **Container** | `brainlife/ants:2.2.0.1` |
| **Resources** | 1 CPUs |
| **Run it** | [doi.org/10.25663/brainlife.app.535](https://doi.org/10.25663/brainlife.app.535) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `t1` | `neuro/anat/t1w` | yes | T1-weighted image to preprocess. |
| `mask` | `neuro/mask` | yes | brain mask |
| `affine` | `neuro/transform/nifti` | yes | reorientation matrix |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `T1_reoriented_N4` | `neuro/anat/t1w` | T1w reoriented to the MNI152 (AC-PC) orientation and N4 bias-field corrected. |
| `mask_reoriented` | `neuro/mask` | Brain mask resampled with the same reorientation. |

<!-- brainlife-app:end -->

## Running the App

### On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.535](https://doi.org/10.25663/brainlife.app.535), choose `neuro/anat/t1w`, `neuro/mask`, `neuro/transform/nifti` from your project and press **Execute**. The results are saved to your project as `neuro/anat/t1w`, `neuro/mask`.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/) (the App runs in `brainlife/ants:2.2.0.1`), [`jq`](https://jqlang.github.io/jq/).

1. Clone this repository.
2. Create `config.json` with the paths to your inputs and the parameters:

   ```json
   {
       "t1": "/path/to/t1/t1",
       "mask": "/path/to/mask/mask",
       "affine": "/path/to/affine/affine"
   }
   ```

3. Run `./main`.

## Citing

If you use this App, please cite it, the software it builds on and brainlife.io:

- DBB_preprocessing_t1w. brainlife.io App. [doi:10.25663/brainlife.app.535](https://doi.org/10.25663/brainlife.app.535)
- Amorosino G, Peruzzo D, Redaelli D, Olivetti E, Arrigoni F, Avesani P. DBB - A Distorted Brain Benchmark for Automatic Tissue Segmentation in Paediatric Patients. NeuroImage 119486 (2022). [doi:10.1016/j.neuroimage.2022.119486](https://doi.org/10.1016/j.neuroimage.2022.119486)
- Avants et al. A reproducible evaluation of ANTs similarity metric performance in brain image registration. *NeuroImage* 54:2033-2044 (2011). [doi:10.1016/j.neuroimage.2010.09.025](https://doi.org/10.1016/j.neuroimage.2010.09.025)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Authors

Gabriele Amorosino

**Contributors**

Matteo Ballabio
    Paolo Avesani
