######
##
## 02-project-setup.R
##
## Description: this function builds the *0 source files into a temporary directory.  It also
## Runs k-fold cross-validation.
##
########

## ----command line parsing ----------------------------------
#get command line arguments
args <- commandArgs(trailingOnly = TRUE)

#get variable arguments
outcome <- as.character(args[[1]])
binarize <- as.logical(args[[2]])
results_directory <- as.character(args[[3]])

print(outcome)
print(binarize)
print(results_directory)

## ----load packages----------s------------------------
pacman::p_load(tidyverse, fs, knitr)

## ----source files-----------------------------------
source_dir <- "r_project_source"

print('Creating source directory...')
dir_create(source_dir)

# get only .Rmd files and source them
list.files(pattern = "[0-8]0-\\w{1,}-?\\w{1,}.Rmd$") %>% 
  map(purl)

# move source files to temporary directory
list.files(pattern = "[0-8]0-\\w{1,}-?\\w{1,}.[R]$") %>% 
  map(file_move, new_path = str_c(source_dir, '/'))

## ---- check for kfold -----------------------------------
fbase <- '/scratch/p_gaydosh_lab/DSI/'
outcome_dir <- str_c(fbase, outcome)
print('Checking your kfold file...')

## check to see if kfold files exist, and if they don't, create them
if(!dir_exists(outcome_dir)){
  print(str_c("the directory ", outcome_dir, " does not appear to exist.  Creating..."))
  
  #create the outcome directory
  dir_create(outcome_dir)
}

#check to see if there's a kfold file in the directory
pat <- 'kfold'
dir_contents <- list.files(outcome_dir)
in_files <- map(dir_contents, function(x) grep(pat, x))
res <- unlist(in_files)

#if there isn't a kfold file, create them with the args above
if(sum(res)==0)
  print("Looks like you haven't made your kfold splits yet.  Making them now...")
  source("86-slurm-kfold-helper.R")

## ---- Check for results directory -----------------------------------
print('Checking your results directory...')
results_dir <- str_c(fbase, results_directory)

if(!dir_exists(results_dir)){
  print(str_c("Looks like your desired outcome directory: ", results_dir, " doesn't exist.  Creating..."))
  dir_create(results_dir, recurse=TRUE)
}

print("Setup file has finished.")



