#!/bin/bash
#SBATCH --mail-user=charreau.s.bell@vanderbilt.edu
#SBATCH --mail-type=ALL
#SBATCH --account=p_dsi
#SBATCH --ntasks=12
#SBATCH --time=05:00:00        # 5 hours
#SBATCH --mem=32GB
#SBATCH --array=1-2
#SBATCH --constraint=skylake
#SBATCH --output=R_slurmjob_%A_task_%a.out

#Variable inputs
OUTVAR=h5mn8
LEGIT_SKIP=TRUE
SKIP_VAR=NULL
RESULTS_DIR=$OUTVAR/'results_test_run'
NB_FILE='81-compute-suicidal'
N_BOOT=2

#Load the relevant modules using Lmod
module load GCC/8.2.0 OpenMPI/3.1.4 Intel/2019.1.144 IntelMPI/2018.4.274 R/3.6.0

#Run the R desired R script using the desired file inputs
Rscript --vanilla 02-project-setup.R $OUTVAR $LEGIT_SKIP $SKIP_VAR $RESULTS_DIR
Rscript --vanilla 01-slurm-experiments.R $OUTVAR $NB_FILE $N_BOOT ${SLURM_ARRAY_TASK_ID} $RESULTS_DIR
Rscript --vanilla 03-rm-rsource.R