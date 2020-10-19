# Running Despair Experiments through SLURM

# Pre-requisites
You'll need to have the repo somewhere in your home directory on ACCRE.  If you don't already have this folder on your home directory, the easiest way is to clone the repo as outlined in the following steps.

1. Go to GitHub page for despair project
2. Click on green Code button
3. Click on clipboard to copy location of repository
4. Navigate to [ACCRE portal](https://portal.accre.vanderbilt.edu) and sign in using your Vanderbilt VUNetID and *ACCRE* password
5. Click `Clusters` on the Menu bar and select `C7 ACCRE Access`.  Enter your *ACCRE* password if prompted.
6. Type: `git clone` and paste in the repository location copied from GitHub (i.e., your total command will look like `git clone https://[repo link].git`) and press enter.
7.  Enter your GitHub credentials; you'll see some activity that shows that the repo has now been cloned.

Take note of the where you are on ACCRE; to do this, use the command line again and type `pwd`.  This is the directory where all of your despair code is and where your output files will be stored.  You'll run everything from here, so take note now.

# Setting up your experiment
Here, you'll need to set up the parameters of your experiment.  This includes technical parameters including the number of bootstraps, the hyperparameters you'll search, whether the variable you're investigating is already binarized (is it already 0/1, or is it more like 0-30 and needs to be re-binarized into 0/1?), and what evaluation metrics you'll use (is your variable distribution balanced or imbalanced?).  You'll also fill out logistical information including the number of bootstraps to run, the save directory, and how many processors you'll be running on.  To do this, execute the following steps:

1.	Go to portal.accre.vanderbilt.edu and log in
2.	Go to interactive apps on top bar, select RStudio Server from drop down menu
3.	Keep default settings (unless you know it needs to be changed) and then click Launch
4.	While waiting for job, there are two options for next step to set up for later: command line OR go to Clusters on website bar and select shell access from menu.  For simplicity, just go to `Clusters` and click `C7 ACCRE Access`.  Enter your password if prompted.
5.	Once job is ready, click on Connect to RStudio Server
6.	Open despair project using the `File` drop down menu on RStudio.

## Preliminary investigation
If you already know everything about your variable, you can skip to the `Detailed experiment` section below.  Otherwise, study your variable using the instructions below so that you can make informed modeling decisions.

If you don't already have a 70-series notebook for your variable, you'll need to create one.  To do this, use file 71-experiments-suicidal.Rmd if you have an already binarized variable (or constructed), or 71-experiments-prob-drinking.Rmd if you have one that needs to be binarized.  Make a copy of one of these, and renumber and rename accordingly.  Now, you'll start your preliminary investigation.

1. Open your notebook, and change the variable name to the variable name of interest and other markdown details.
2. Make sure `binarize` is set correctly in the dataset generation function.
3. Go down to where the bootstraps are performed, and choose a small number of bootstraps.
4. Run the bootstrapping cell and all above.
5. **LOOK** at the plots that are produced.  Do you see anything wrong with any of the predictors?  Do you see any extremely high correlation among the predictors?  Do you see anything that seems to be recoded incorrectly?  Inspect critically and make sure that your assumptions are matching what you see here.
6. **LOOK** at the outcome variable distribution plots.  Do they look about right?  Do the math.  Are the NAs correctly dropped?  Did your recoding seem to work correctly?  Make sure this is the case.
7. **LOOK** at the outcome variable distribution plot.  Is it balanced or imbalanced?  If it's imbalanced, you may want to make some decisions about which metrics to use to select your best performing model (e.g., `pr_auc` - see suicidal notebook)
8. Run a few more cells after your bootstraps and look at the performance.  Is the performance OK?  If it, try to change around some of the hyperparameters and see if you can get better results.

Once you've determined a good set of hyperparameters and your evaluation metric, you can move on to the next step.

## Detailed experiment
Now, you'll create two 80-series notebook to match what you did with your 70-series notebook, except on a far grander scale using SLURM.  To do this, execute the following steps.

1.  To start creating files for a new variable, we will use copies of other files: `81-compute-suicidal` and `81-interpret-suicidal`
      a.	Select the checkboxes next to the file names
      b.	Go to “More” (with gear icon) on the small bar right above list of files and click copy
      c.	Rename new files according to 70 series variable order (e.g. 84-interpret-prob-drinking)

### Experiment settings 

2.	Open your new `8x-compute-` file.
3.	Change the title string and other markdown mentions of the variables and predictors you'll be using
4. Replace outcome variable name (line 44)
5.	Edit hyperparameters if known from previous exploration (like stopping metric)
6.	In generating dataset, make sure `binarize` is set to appropriate truth value (line 48)

### SLURM settings

7. Open `01-slurm-experiments.SLURM`
8.	Change email to your own email if it isn't already changed
9.	Make sure you have 24 cores and 64GB memory setting
10.  Adjust array and N_BOOT as needed (e.g., if this is your first run set `array` to be `1-3` and `N_BOOT` to be `2`. This will give you a good feel about how your R packages are interacting with ACCRE and if everything runs to your expectation)
11.  Change `OUTVAR` to your variable of interest and `BINARIZE` to your required setting.
12.  Change the last half of `RESULTS_DIR` a new folder for your variable
13.  Change `NB_FILE` to the file you're running (e.g., `81-compute-suicidal`)
14.  Save file

# Running your experiment
Make _sure_ you've executed all of the steps in the previous section (`Setting up your experiment`).

1.  Go back to command line or shell (on portal home page, go to `Clusters` then `C7 Shell Access` and enter password)
2.  Type `cd despair` or whatever the path is to your despair directory
3.  Type `sbatch 01-slurm-experiments.SLURM` and press enter.  This runs the SLURM script that you specified in the previous section, which runs the notebook you specified with the settings that you specified.  Take note of the job number that is returned by this command.

# View progress/outputs
After you execute the previous command, SLURM is scheduling your job and deciding when it should run.  When your job does start to run, you will get an email to the address you specified in your SLURM script with the word `BEGAN` in the title.  Once you get this email, you can go back to the shell or command line, in your despair directory, and type: cat `R_slurmjob_(insert job number)_task_1.out`.  Recall that the job number was printed to the screen after the last command.  You can also get it from your email.

On your first run, you should monitor this output file during execution, and if your job starts failing in particular spots, you can see where it failed.  Peruse this for clues if you run into issues during execution.

When your job is _finished_, you will also get an email from SLURM with `COMPLETED` somewhere in the title if it completed successfully.  If your job failed, you'll get an email that either says `FAILED` if all of your subtask jobs failed or `MIXED` if some of them failed.

# View experiment data results
To view your data outputs:

1. Navigate to ACCRE portal, click Files on the top bar and select Home Directory on the dropdown menu
2. Click the Go To button on the top bar
3. Type `/scratch/p_gaydosh_lab/`
4. Click `DSI`
5. Select appropriate folder for your variable
6. Select any output of interest and click `View`.
7. **LOOK** at the data that is generated.  For separate tasks, do you accidentally get the same exact results?  Are all of the model seeds different for a single task?  Are they different across tasks?  Make sure that you don't see any technical challenges in the results.
8.  Did you **LOOK** at the data?  Look again!

# Run analysis steps
Now that you've generated all of your data, we'll analyze these outputs using RStudio so we can see graphical results.  To do this, perform the following steps:

1. Go to RStudio portal and open the `despair` project.
2. Open your sister 80-series `interpret` notebook that you created in the `Setting up your experiment` section.
3. Make sure all of the settings match, including the variable you're using, the number of tasks you specified in your SLURM script,  whether the variable should be binarized, and the `scratch` output directory.
4. Run all cells and peruse the outputs.
5. **LOOK** at the results.  Do they make sense?  Are any identical?  **THINK** about what your results mean and whether they make sense!



