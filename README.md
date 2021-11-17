# Objective

This project accompanies Dr. Gaydosh's manuscript titled American Despair? A Machine Learning Approach to Predicting Self-Destructive Behaviors and provides all code necessary to replicate the experimental results. 

## Overview

Files 10 through 60 set the groundwork for generating the datasets, setting up H2O, running the experiments and evaluating the results.

Variables_of_Interest.xlsx is a spreadsheet used to refactor all of the variables used in the experiment. 

h2o-credential.Rmd need only run once before running the experiments. It genererates private H2O credentials that are necessary when using a shared 'super computer' like Vanderbilt's ACCRE to prevent different users sharing the same H2O portal and running into interference.

File Experiment-Outcome.Rmd is the only file that needs to be run. This file serves as an example and the variable can be changed from 'h5mn8' (suicidal ideation) to p_drug (prescription drug use), i_drug (illegal drug use) and hv_drink (our heavy drinking metric). For line #70, use function generate_datasets when running full experiment or function generate_datasets_benchmark when running clinical benchmark experiment with shortened variable list.

The LASSO and Random Forest models are saved as H2O models, and the results lists are saved in an .RData file. The generated graphs can be manually saved by knitting the file to an HTML after the experiment has finished. 

## Steps

1. Generage H2O credentials using h2o-credentials.Rmd (Need to do once)
2. Edit Experiment-Outcome.Rmd
      a. Change variable
      b. Change dataset
3. Run Experiment-Outcome.Rmd
4. Save HTML file
