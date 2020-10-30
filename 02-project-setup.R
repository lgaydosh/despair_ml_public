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
taskid <- as.numeric(args[[4]])

print(outcome)
print(binarize)
print(results_directory)

## ----load packages----------------------------------
pacman::p_load(tidyverse, fs, knitr)

## ----source files-----------------------------------
source_dir <- "r_project_source"
print('Starting setup...')

## ----sleep helper for cluster ------------------------
#We use this function because when we use Sys.sleep,
#it sets the priority of the job to be really low
#and the task sleeps outrageously long
pause_for <- function(pause_secs){
  #pause_secs: integer seconds to pause
  
  right_now <- Sys.time()
  while((as.numeric(Sys.time()) - as.numeric(right_now))<pause_secs){}
}

##----helper for kfold check------------------
check_kfold_exists <- function(dir_out){
  
  if(!file.exists(dir_out)){
    return(FALSE)
  }
  
  #check to see if there's a kfold file in the directory
  pat <- 'kfold_assign_'
  dir_contents <- list.files(dir_out)
  in_files <- map(dir_contents, function(x) grep(pat, x))
  res <- unlist(in_files)
  
  #Check to see if there are any
  if(sum(res)==0){
    return(FALSE)
  } else {
    return(TRUE)
  }
  
}

fbase <- '/scratch/p_gaydosh_lab/DSI/'
outcome_dir <- str_c(fbase, outcome)
results_dir <- str_c(fbase, results_directory)

if(taskid==1){

  print('Creating source directory...')
  dir_create(source_dir)
  
  # get only .Rmd files and source them
  list.files(pattern = "[0-8]0-\\w{1,}-?\\w{1,}.Rmd$") %>% 
    map(purl)
  
  # move source files to temporary directory
  list.files(pattern = "[0-8]0-\\w{1,}-?\\w{1,}.[R]$") %>% 
    map(file_move, new_path = str_c(source_dir, '/'))
  
  ## ---- check for kfold -----------------------------------
  print('Checking your kfold file...')
  
  ## check to see if the outcome directory exists; if not, create it
  if(!dir_exists(outcome_dir)){
    print(str_c("the directory ", outcome_dir, " does not appear to exist.  Creating..."))
    
    #create the outcome directory
    dir_create(outcome_dir)
  }
  
  ## check to see if kfold files exist, and if they don't, create them
  if(!check_kfold_exists(outcome_dir)){
    print("Looks like you haven't made your kfold splits yet.  Making them now...")
    source("86-slurm-kfold-helper.R")
  }
  
  ## ---- Check for results directory -----------------------------------
  print('Checking your results directory...')
  
  if(!dir_exists(results_dir)){
    print(str_c("Looks like your desired outcome directory: ", results_dir, " doesn't exist.  Creating..."))
    dir_create(results_dir, recurse=TRUE)
  } 
} else {
    
  print('Sleeping until task 1 has completed setup to tell me to wake up...')
  while(!(dir_exists(results_dir) & dir_exists(outcome_dir) & check_kfold_exists(outcome_dir))) pause_for(10)
  print('Looks like everything has been created.  Waking up to continue...')
  
  }

print("Setup file has finished.")



