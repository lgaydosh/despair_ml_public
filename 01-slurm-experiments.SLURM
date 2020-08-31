#!/bin/bash
#SBATCH --mail-user=charreau.s.bell@vanderbilt.edu
#SBATCH --mail-type=ALL
#SBATCH --account=p_dsi
#SBATCH --ntasks=12
#SBATCH --time=05:00:00        # 5 hours
#SBATCH --mem=32GB
#SBATCH --array=1-3
#SBATCH --constraint=skylake
#SBATCH --output=R_slurmjob_%A_task_%a.out

#Load the relevant modules using Lmod
module load GCC/8.2.0 OpenMPI/3.1.4 Intel/2019.1.144 IntelMPI/2018.4.274 R/3.6.0

#Run the R desired R script using the desired file inputs
Rscript --vanilla 02-build-rsource.R
Rscript --vanilla 01-slurm-experiments.R 3 ${SLURM_ARRAY_TASK_ID}
Rscript --vanilla 03-rm-rsource.R