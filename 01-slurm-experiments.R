#######
##
## slurm_experiments.R
##
## The purpose of this script is to source the desired 80 series notebook and then run it.
## The outputs will be in the directory of your choosing.
##
#######

args <- commandArgs(trailingOnly = TRUE)

#expected command line parameters
n_boot = as.numeric(args[[1]])
task_ID = as.numeric(args[[2]])

#compatibility with SLURM
.libPaths("~/R/x86_64-pc-linux-gnu-library/3.6")
chooseCRANmirror(graphics=FALSE, ind=1)

# Get required packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(knitr, stringr, readr, fs)

#other parameters
notebook_file = '81-compute-suicidal'
outcome = 'h5mn8'
results_directory = str_c(outcome, '/results_run_2')
kfold_file = str_c(outcome, '/kfold_assign_3895_tts_9384.csv')

# Convert the 70 series notebook to a script
purl(paste0(notebook_file, '.Rmd'))

# Get the filename
r_file = paste0(notebook_file, '.R')

# Run the file as a script; note that all parameters are dumped into the global environment
source(r_file)

# Delete the generated file
if(file_exists(r_file)){
  
  #tryCatch to handle race conditions among several processors
  tryCatch({
    file_delete(r_file)
  }, error = function(e){
    print(str_c("file ", r_file, " already deleted by another process.  Continuing..."))
  })
}

