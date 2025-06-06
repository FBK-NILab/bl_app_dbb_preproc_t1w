#! /bin/bash


###################################################################################################################
######### 	Functions
###################################################################################################################

function Usage {
    cat <<USAGE
    

Usage:

` basename $0 ` -i <T1.ext> -t <template.ext> [-o <outputdir>] [-a <affine.ext>] [-m <mask.ext>] [-n <num>]

Main arguments:
    
	-i, --input         T1-w image to be preprocessed    
	-t, --template      template as reference space to be reoriented
   
General Options:

	-o, --outputdir     if not provided, the scripts create the folder 
	-a, --affine        affine matrix to perform rigid transformation to the template
	-m, --mask          brain mask to limit Bias-field correction on these voxels     
	-n, --nthreads      number of threads      	

 
USAGE
    exit 1

}

str_index() {    
                
                ############# ############# ############# ############# ############# ############# 
                ############  Trova il primo indice di una sottostringa in una stringa  ########### 
                ############# ############# ############# ############# ############# #############   

		if [ $# -lt 2 ]; then							# usage dello script							
			    echo $0: "usage: str_index <string> <substrin> "
			    return 1;		    
		fi       

                x="${1%%$2*}";   
                [[ $x = $1 ]] && echo -1 || echo ${#x}; 
                };



exists () {
   
                ############# ############# ############# ############# ############# ############# #############
                ##############  	  Check existence of a file or directory                        ############# 
                ############# ############# ############# ############# ############# ############# #############  		
                      			
		if [ $# -lt 1 ]; then
		    echo $0: "usage: exists <filename> "
		    echo "    echo 1 if the file (or folder) exists, 0 otherwise"
		    return 1;		    
		fi 
		
		if [ -d "${1}" ]; then 

			echo 1;
		else
			([ -e "${1}" ] && [ -f "${1}" ]) && { echo 1; } || { echo 0; }	
		fi		
		};


remove_extx () {
	
	local result=$( echo ` basename $1 | cut -d '.' -f 1 ` )
	
	local idx=$( str_index ${result} '.' )
	
	if [ ${idx} -ne -1 ]; then
		
		local extension="${result##*.}"		
		
		if [ "${extension}" == "nii" ]; then
			local result=$( echo ` basename $result | cut -d '.' -f 1 ` )	
		fi 
	fi
	
	echo ${result}
		
}

imm_dim() {	

                 	
		sizem=$(PrintHeader $1 2)
		dimm=$( grep -o "x" <<<"$sizem" | wc -l)
		dimm=$(( $dimm+1 ))
		echo $dimm
		
		};
		

imm_size() { 

                
                local stringsize=$(PrintHeader $1 2)
				local sep="$2"
				[ -z $sep ] && { sep=',';}
				[ $sep == 'space' ] && { sep=' ';}
				local commasize=${stringsize//'x'/$sep}
				echo ${commasize}

		};

imm_mean() {     

                
				local subs=$1;
				local dim=$( imm_dim $1 )
				local stasts=( $(ImageIntensityStatistics ${dim} ${1} ) )
				echo ${stasts[12]}
		};

imm_max() {     

		local subs=$1;
		local dim=$( imm_dim $1 )
		local stasts=( $(ImageIntensityStatistics ${dim} ${1} ) )
		echo ${stasts[21]}
		};
		
imm_setAverage () {

		if [ $# -lt 2 ]; then							# usage of the function							
		    echo $0: usage: "imm_setAverage <imm_input.ext> <imm_output.ext> [<value>]"		
		    return 1
		fi

		local input_=$1
		local output_=$2
		local MEAN_INTENSITY=$3
		local dim=$( imm_dim $1 )
		[ -z ${MEAN_INTENSITY} ] && { MEAN_INTENSITY=100; }
		
		AVERAGE=$( imm_mean ${input_} )
		
		ImageMath ${dim}  ${output_} /  ${input_}  ${AVERAGE}
		ImageMath ${dim}  ${output_} m ${output_}  ${MEAN_INTENSITY}

 }	


imm_thr () {
		
		local t1=$1
		local t1_out=$2
		local dim=$( imm_dim $t1 )
		local max=$( imm_max $t1 )
		local t1_thr=$( dirname $t1 )'/'$( remove_extx $t1 )'_thrmask.nii.gz'
		ThresholdImage ${dim} ${t1} ${t1_thr} 0 ${max} 
		ImageMath ${dim} ${t1_out} m ${t1} ${t1_thr}
}

###################################################################################################################
######### 	Input Parsing
###################################################################################################################

# Provide output for Help
if [[ "$1" == "-h" || "$1" == "--help" ]];
  then
    Usage >&2
  fi

nargs=$#

if [ $nargs -lt 2   ];
  then
    Usage >&2


  fi



# As long as there is at least one more argument, keep looping
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        
        -h|--help)        
        Usage >&2
      	exit 0
        ;;    
        -i|--input)
        shift
        input_=${1}
        let nargs=$nargs-1
        ;;
        --input=*)
        input_="${key#*=}"
        ;;    
        -t|--template)
        shift
        template=${1}
        let nargs=$nargs-1
        ;;
        --template=*)
        template="${key#*=}"
        ;; 
        -o|--outputdir)
        shift
        outputdir=${1}
        let nargs=$nargs-1
        ;;
        --outputdir=*)
        outputdir="${key#*=}"
        ;;
        -a|--affine)
        shift
        affine="${1}"
        let nargs=$nargs-1
        ;;
        --affine=*)
        affine="${key#*=}"
        ;;
        -m|--mask)
        shift
        T1_mask="${1}"
        let nargs=$nargs-1
        ;;
        --mask=*)
        T1_mask="${key#*=}"
        ;;
        -n|--nthreads)
        shift 
        nthreads="$1"
        let nargs=$nargs-1
        ;;
        --nthreads=*)
        nthreads="${key#*=}"
        ;;
        -f|--force)        
		force=1	
        ;;
        -v|--verbose)        
		verbose=1	
        ;;       
        *)
        # extra option
        echo "Unknown option '$key'"
        ;;
    esac
    # Shift after checking all the cases to get the next option
    shift
done

###################################################################################################################
######### 	Set number of threads
###################################################################################################################

[ -z $nthreads ] && { nthreads=2; }

OMP_NUM_THREADS=${nthreads}
ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=${nthreads} 										
export OMP_NUM_THREADS
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS 


###################################################################################################################
######### 	Reorientation
###################################################################################################################



dim=3

#template=${FSLDIR}'/data/standard/MNI152_T1_1mm.nii.gz'

if [ -z ${outputdir} ]; then
	outputdir=$( dirname $input_ )'/T1w_preproc/'
fi

basena=$( remove_extx $( basename $input_ ) )

if [ -z ${affine} ]; then

	affine=${outputdir}/${basena}_2MNI_0GenericAffine.mat
fi


[ -d ${outputdir} ] || { mkdir ${outputdir} ; }


input_reo=${outputdir}'/'$( remove_extx $input_	)"_reoriented.nii.gz"

dim=$( imm_dim ${input_} )

if [ $( exists $input_reo ) -eq 0 ]; then

	if [ $( exists ${affine} ) -eq 0 ]; then
		echo "No affine matrix provided."
		echo "Perform ac-pc reorientation to MNI space..."
			
		its=10000x111110x11110
		percentage=0.3				
		antsRegistration -d ${dim} -v 1 -r [ ${template} , ${input_}  ,1]  \
                        -m mattes[  ${template} , ${input_}  , 1 , 32, regular, $percentage ] \
                         -t translation[ 0.1 ] \
                         -c [$its,1.e-8,20]  \
                        -s 4x2x1vox  \
                        -f 6x4x2 -l 1 \
                        -m mattes[  ${template} , ${input_}  , 1 , 32, regular, $percentage ] \
                         -t rigid[ 0.1 ] \
                         -c [$its,1.e-8,20]  \
                        -s 4x2x1vox  \
                        -f 3x2x1 -l 1 \
                       -o ${outputdir}/${basena}_2MNI_ 
						
						
	fi

	if [ $( exists $input_reo ) -eq 0 ]; then
		echo "apply transform..."
		antsApplyTransforms \
						-d ${dim} \
						-i ${input_} \
						-o ${input_reo} \
						-r ${template} \
						-t ${affine} \
						-n BSpline

	fi

fi
###################################################################################################################
######### 	Bias Field Correction
###################################################################################################################


if [ -n "${T1_mask}" ] ; then


	echo "reorient mask..."
	T1_mask_reo=${outputdir}'/'$( remove_extx ${T1_mask} )'_reoriented.nii.gz'
	
	antsApplyTransforms \
					-d ${dim} \
					-i ${T1_mask} \
					-o ${T1_mask_reo} \
					-r ${template} \
					-t ${affine} \
					-n 'Linear'
	
	ThresholdImage ${dim} ${T1_mask_reo} ${T1_mask_reo} 0.5 $( imm_max ${T1_mask_reo} )				
	mask_opt=" -x ${T1_mask_reo} "



fi

		
input_N4=${outputdir}'/'$( remove_extx $input_reo	)"_N4.nii.gz"
if [ $( exists $input_N4 ) -eq 0 ]; then
	echo "set average value to 100..."
	imm_setAverage ${input_reo} ${input_reo}
	
	N4BiasFieldCorrection 	-d ${dim} \
							-i ${input_reo} \
							-o ${input_N4} \
							-v ${mask_opt} ; 
	echo "threshould image..."
	imm_thr ${input_N4}  ${input_N4}
        imm_setAverage ${input_N4} ${input_N4}

fi
