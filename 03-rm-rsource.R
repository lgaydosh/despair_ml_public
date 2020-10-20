######
##
## 03-em-rsource.R
##
## Description: this function builds the *0 source files into a temporary directory
##
########

## ----load packages----------s------------------------
pacman::p_load(tidyverse, fs, knitr)

## ----source files-----------------------------------
source_dir <- "r_project_source"

print('Deleting source directory...')

# delete temporary directory
if(dir_exists(source_dir)){
  dir_delete(source_dir)
}

print('Experiment completed.')