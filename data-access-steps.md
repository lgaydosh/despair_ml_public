# Data Access through ACCRE

The data to be used in this project is restricted-access, and we will be accessing the data through ACCRE.  Make sure you heed the guidelines here about practices and requirements for responsibly using the data.

The final procedure used to access the data is still under construction by ACCRE, but they have provided a set of steps that we can use in the meantime.  The procedure is as follows:

## Pre-requisites: Modify your .bashrc for directory mount
Your .bashrc file gives the operating system information about your computing environment.  We need to modify this so that we're able to mount the remote smb filesystem.  Once this is set up the first time, you never need to modify this again.

You can do this through the command line, but you can also do this through ACCRE's [portal](portal.accre.vanderbilt.edu).  This latter method is what I will describe here.

Log into [portal](portal.accre.vanderbilt.edu) using your ACCRE credentials.  Click the `Files` drop-down menu at the top of the screen and choose `Home Directory`.  If not already selected, click the checkbox at the top right to `Show Dotfiles`.  

Find your .bashrc file and click on it.  Then, at the top of the screen, click `Edit`.  Copy and paste the following lines at the end of your .bashrc file:

```
################################
# START Despair project settings

function despair_start()
{
    pgrep -u $(whoami) dbus-daemon  && \
    [ -f ~/.saved-dbus-env ]        && \
    source ~/.saved-dbus-env        || \
    dbus-launch > ~/.saved-dbus-env && \
    source ~/.saved-dbus-env
            
    export $(dbus-launch)
    
    #Create a symlink in my home directory linked to global gvfs bellcs1 folder 
    [ ! -L "${HOME}/gvfs" ] && ln -s /run/user/`id -u`/gvfs ${HOME}/gvfs
    
    echo "Initialized despair project settings."
}

# END Despair project settings
################################
```
Make sure you haven't left a blank line at the end of your .bashrc file.  Click the blue `Save` button at the top of the screen.

## 1. Open R Studio from the ACCRE *Dev*Portal
Navigate to ACCRE's [DevPortal](https://devportal.accre.vanderbilt.edu) (executing this procedure from the standard portal website will not work) and log in using your ACCRE credentials.  Click the `Interactive Apps` drop-down menu and select `RStudio Server GPU`.  Input your desired resources (e.g., p_dsi_acc user group, 24-48 hours, 1 GPU resource, Turing GPU) and launch your session.

You will be taken to the `My Interactive Sessions` page where your R Studio session will be created.  Once your session is ready **take note of the GPU node where your session is allocated.**  This will be on the first line of your session info in the **Host** field.  For example, if gpu0032 was allocated for your job, the line will read `Host: gpu0032.vampire`.  You will need this information later.

Click `Connect to R Studio Server` and wait for your session to load.  If you experience any strange errors, try to click refresh in your browser window.  This usually resolves the issue.

## 2. Setup environment and mount filesystem

After you have executed Step 1, open up a bash terminal on your computer.  Ssh into ACCRE using the command: `ssh vunetid@login.accre.vanderbilt.edu` where `vunetid` is your vunetid.  Enter your password.

Now, we're going to ssh into the GPU that was allocated to you in Step 1.  We're able to do this because the GPU is already allocated to our vunetid (no, we can't just casually ssh into any of ACCRE's GPU compute nodes!).  Type `ssh gpuxxxx` where `gpuxxxx` is the GPU you were allocated in Step 1.  You may need to enter your password again.

Now, type `despair_start`.  This runs the function that we created in the setup, and our GPU environment is now set to be able to mount the remote filesystem.  Now, let's mount the filesystem!  To do this, type `gio mount smb://vu1file.it.vanderbilt.edu/gaydosh_addhealth/gaydosh/`

You'll see some prompts for you to enter your username, domain, and password.  These are your VUNetid ID/password and the domain is VANDERBILT.

The file directory is now mounted!  If you want to view the data, type `cd ~/gvfs` and then `cd` into the single directory inside.

For ease of future steps, you may want to keep this bash terminal open.

## 3. Use R Studio to analyze the data

## 4. Unmount the file system after use!
After you're done with your session, before you delete your R Studio session, **unmount the remote filesystem**.  To do this, go back to your bash terminal and type `gio mount -u smb://vu1file.it.vanderbilt.edu/gaydosh_addhealth/gaydosh/`.  This unmounts the remote filesystem.  Back in the devportal, delete your session.

Happy computing!
