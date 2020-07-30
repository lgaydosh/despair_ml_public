#######
##
## slurm_experiments.R
##
## The purpose of this script is to source the desired 70 series notebook and then run it.
## The outputs will be in the directory of your choosing.
##
#######

#expected command line parameters
notebook_file = '71-experiments-suicidal'
from_script = TRUE
results_directory = '.'
random_seed_file = 'random_seeds.csv'
random_seed_no = 5
no_bs = 2
task_ID = 1

# Get required packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(knitr, readr, fs)

# Convert the 70 series notebook to a script
purl(paste0(notebook_file, '.Rmd'))

# Get the filename
r_file = paste0(notebook_file, '.R')

# Lookup random seed
rs_data = read_csv(random_seed_file)
random_seed = rs_data[[random_seed_no]]

# Run the file as a script; note that all parameters are dumped into the global environment
source(r_file)

# Delete the generated file
file_delete(r_file)

