## ----library imports-----------------------------------------------------
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, furrr, h2o, tictoc, rsample)
future::plan(multiprocess)


## ----import source files, warning=FALSE, message=FALSE-------------------
source("function_import.R")


## ----seeding settings----------------------------------------------------
no_folds=5
seed = 9384
seeds = c(2435, 9834, 7903, 3895, 1236)
filebase = '/scratch/p_gaydosh_lab/'


## ----splitting helper function-------------------------------------------
split_extract <- function(d_split, fold_no){
  fold_assigns <- d_split %>%
    assessment() %>%
    mutate(fold_assign = rep(fold_no, nrow(.))) %>%
    select(fold_assign, everything())
  
  return(fold_assigns)
}


## ----xval saving function------------------------------------------------
xval_save_helper <- function(in_data, xseed, tts_seed, strat_var, no_folds, out_var, filebase){
  
  set.seed(xseed)
  xfolds <- in_data %>%
    vfold_cv(v = no_folds, repeats=1, strata = strat_var) %>%
    pull(splits) %>%
    map2_df(seq(1, no_folds), split_extract) %>%
    select(aid, fold_assign)
  
  #create save variable
  save_csv <- str_c(filebase, '/DSI/', out_var, '/kfold_assign_', xseed, '_tts_', tts_seed, '.csv')
  write_csv(xfolds, save_csv)
  
  return(xfolds)
}


## ----generate data-------------------------------------------------------
#create data in specified form
dataset_list <- generate_datasets(outcome, legit_skip=legit_skip, skip_var = skip_var, 
                                  filebase=filebase, seed_val=seed)

#parse out dataset components
full_dataset <- dataset_list$full_dataset
ds_raw <- dataset_list$ds_raw_outcome
ds <- dataset_list$ds_final

#just select a few variables
ds <- ds %>% dplyr::select(aid, all_of(outcome))

#ml splits of the data
training_df <- dataset_list$training_df
validation_df <- dataset_list$validation_df
testing_df <- dataset_list$testing_df

#working_ds %>% glimpse()


## ----actually create and save xval folds---------------------------------
test_splits <- map(seeds, ~xval_save_helper(in_data = training_df, xseed=.x, strat_var=outcome, no_folds=no_folds,
                                            tts_seed = seed, out_var=outcome, filebase=filebase))
test_splits

