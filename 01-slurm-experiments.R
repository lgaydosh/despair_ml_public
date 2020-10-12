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
outcome <- as.character(args[[1]])
notebook_file <- as.character(args[[2]])
n_boot <- as.numeric(args[[3]])
task_ID <- as.numeric(args[[4]])
results_dir <- as.character(args[[5]])

#compatibility with SLURM
.libPaths("~/R/x86_64-pc-linux-gnu-library/3.6")
chooseCRANmirror(graphics=FALSE, ind=1)

# Get required packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(knitr, stringr, readr, fs)

#other parameters
fbase <- '/scratch/p_gaydosh_lab/DSI/'
results_directory = str_c(fbase, results_dir)
kfold_file = str_c(fbase, outcome, '/kfold_assign_3895_tts_9384.csv')

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

