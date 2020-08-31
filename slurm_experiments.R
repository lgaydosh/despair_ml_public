#######
##
## slurm_experiments.R
##
## The purpose of this script is to source the desired 80 series notebook and then run it.
## The outputs will be in the directory of your choosing.
##
#######

#expected command line parameters
n_boot = 2
task_ID = 1

#other parameters
notebook_file = '81-compute-suicidal'
outcome = 'h5mn8'
results_directory = str_c(outcome, '/results_run_1')
kfold_file = str_c(outcome, '/kfold_assign_3895_tts_9384.csv')

# Get required packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(knitr, readr, fs)

# Convert the 70 series notebook to a script
purl(paste0(notebook_file, '.Rmd'))

# Get the filename
r_file = paste0(notebook_file, '.R')

# Run the file as a script; note that all parameters are dumped into the global environment
source(r_file)

# Delete the generated file
file_delete(r_file)

