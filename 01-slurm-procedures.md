1.	Go to portal.accre.vanderbilt.edu and log in
2.	Go to interactive apps on top bar, select RStudio Server from drop down menu
3.	Keep default settings (unless you know it needs to be changed) and then click Launch
4.	While waiting for job, there are two options for next step to set up for later: command line OR go to Clusters on website bar and select shell access from menu
5.	Once job is ready, click on Connect to RStudio Server
6.	Open despair
7.	If you don’t have despair:

      a.	Go to GitHub page for despair project
      
      b.	Click on green Code button
      
      c.	Click on clipboard to copy location of repository
      
      d.	Go to shell or commandline
      
      e.	Type: git clone
      
      f.	Paste the repository location copied from GitHub
      
      g.	Press enter
      
      h.	Will need to enter GitHub login
      
8.	In Git tab in upper right quadrant of RStudio, switch to slurm-fixes-exp branch from dropdown list (If it’s not there, go to master branch and click green down arrow for pull)
9.	To start creating files for a new variable, we will use copies of other files: 81-compute-suicidal and 81-compute-suicidal

      a.	Select the checkboxes next to the file names

      b.	Go to “More” (with gear icon) on the small bar right above list of files and click copy

      c.	Rename new files according to 70 series variable order (e.g. 84-interpret-prob-drinking)
      
10.	Open new computer file
11.	Change the title string and other mentions of what variable
12.	Replace outcome variable name (line 44)
13.	Edit hyperparameters if known from previous exploration (like stopping metric)
14.	In generating dataset, make sure legit_skip is set to appropriate truth value (line 48)
15.	Go back to commandline or shell
16.	Type cd despair
17.	Go back to Rstudio and open 01-slurm-experiments
18.	Change email to your own email!
19.	Keep 24 cores and 64GB memory setting
20.	Adjust array and N_BOOT as needed
21.	Change OUTVAR to your variable of interest and LEGIT_SKIP and SKIP_VAR accordingly
22.	Change RESUTS_DIR to new folder for your variable
23.	Change NB-FILE to your file
24.	Save file
25.	Go back to commandline or shell
26.	Type sbatch 01-slurm-experiments.SLURM
27.	Press enter
28.	After job has started to run, in shell or commandline, type: cat R_slurmjob_(insert job number)_task_1.out
29.	Shows file output from that function
30.	To view files another way, going back to accre portal, you can click Files on the top bar and select Home Directory on the dropdown menu
31.	Click the Go To button on the top bar
32.	Type /scratch/p_gaydosh_lab/
33.	Click DSI
34.	Select appropriate folder for your variable

