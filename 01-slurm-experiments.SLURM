#!/bin/bash
#SBATCH --mail-user=rachel.fan@vanderbilt.edu
#SBATCH --mail-type=ALL
#SBATCH --account=p_dsi
#SBATCH --ntasks=24
#SBATCH --time=30:00:00        # 5 hours
#SBATCH --mem=128GB
#SBATCH --array=1-30
#SBATCH --constraint=skylake
#SBATCH --output=R_slurmjob_%A_task_%a.out

#Variable inputs
OUTVAR=p_drug
BINARIZE=FALSE
RESULTS_DIR=$OUTVAR/'results_3.25'
NB_FILE='83-compute-pr-drug'
N_BOOT=25

#Load the relevant modules using Lmod
module load GCC/8.2.0 OpenMPI/3.1.4 Intel/2019.1.144 IntelMPI/2018.4.274 R/3.6.0

#Run the R desired R script using the desired file inputs
Rscript --vanilla 02-project-setup.R $OUTVAR $BINARIZE $RESULTS_DIR ${SLURM_ARRAY_TASK_ID}
Rscript --vanilla 01-slurm-experiments.R $OUTVAR $NB_FILE $N_BOOT ${SLURM_ARRAY_TASK_ID} $RESULTS_DIR
Rscript --vanilla 03-rm-rsource.R