######
##
## 02-build-rsource.R
##
## Description: this function builds the *0 source files into a temporary directory
##
########

## ----load packages----------s------------------------
pacman::p_load(tidyverse, fs, knitr)

## ----source files-----------------------------------
source_dir <- "r_project_source"

dir_create(source_dir)

# get only .Rmd files and source them
list.files(pattern = "[0-6]0-\\w{1,}-?\\w{1,}.Rmd$") %>% 
  map(purl)

# move source files to temporary directory
list.files(pattern = "[0-6]0-\\w{1,}-?\\w{1,}.[R]$") %>% 
  map(file_move, new_path = str_c(source_dir, '/'))