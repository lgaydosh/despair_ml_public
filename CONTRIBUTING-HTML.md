# Contributing HTML Files to the Repo
> Protocol and expectations

## Motivation
The analysis we perform benefits from visualizations and commmentary to describe the results.  Because of the nature of the AddHealth data and the potential for accidentally displaying subject data, we have avoided checking these into the repo.  However, all of our files must now be stored on `/scratch` on ACCRE, which is not backed up, instead of vu1file.  If these `/scratch` files are accidentally deleted or the backing drives fail, our html results would be lost forever and would have to be regenerated.  In this document, we outline a protocol which:
1.  Allows us to have backup of our results, and 
2.  Ensures subject data is not accidentally commited to the repo in the form of html files.

## Contribution Protocol
The following steps are to be performed if you have generated results or visualizations in a 70 series or 80 series (or other visualizations such as EDA) notebook. 

1.  As normal, add/commit/push your **code changes** (e.g., `.Rmd`, `.R`, `.SLURM` **only**) as you normally would to GitHub.  At this point, make sure that you have **saved** the results (**not committed**) the html files to the relevant repo directory (`html_results`).  
2.  Submit your pull request and identify one or more reviewers.  If you have added any outputs (changes to visualizations, summary tables), **make sure to indicate this in the PR comments for the submission so the reviewer can make sure to look at this section.**  
3.  Do all tasks required for the PR to be approved.  
4.  After the reviewer submits the approval, **set up a Zoom session in which you show them the html results**.  **Do NOT record this session.**  
5.  The reviewer should ensure that there are no tables which show subject data.  
6.  After the reviewer agrees, go back to ACCRE, add + commit your html file, and push this up to GitHub on your branch.  Note that because these files are in the `.gitignore` (don't modify this), you'll need to modify your add command to be `git add -f html_results/filename.nb.html`.  The `-f` indicates a force add.
7.  Make sure you look at your new added commit on GitHub and that everything looks right.  
8.  Merge in your pull request.  
9.  Delete your branch.  

## Points of note
1.  **NEVER** commit any html, not even to your local repo, until the reviewer has visually approved the notebook you plan to commit.
2.  Tell your reviewer in your PR commit if you have added any new visualizations or table outputs

