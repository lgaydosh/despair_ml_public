# despair
Prediction of behaviors associated with despair, hypothesized to be responsible for decline of life expectancy in the US

## Background

Prediction of behaviors associated with despair, including suicidal ideation, drug abuse, illicit drug use, opioid use, problematic drinking. The behaviors are associated with despair, which may be responsible for the drop in life expectancy in the US over the last few years. 

## Data

All data is structured. Source files are all SAS export files. This is a large dataset, collected in waves. The most recent is Wave 5, which includes the outcomes. The goal is to predict Wave 5. Note that Wave 5 was carried out in three random samples. Each sample is nationally representative, and are roughly even. These were done sequentially, with one period collected prior to the 2016 election, so their might be some important diffences. 

Extension: Other PIs have smaller datasets with not all of the variables as in the larger dataset, but their is an interest in perhaps applying the model to the other datasets from other PIs. There is also an interest in harmonizing the datasets. One option to build model on the larger set, using only the features in common, the applying to the other. Another possibility is to pretrain a DNN, and use transfer learning.


### Counts

There are approximately 12,000 cases total. 

*Incidence Rates*

Problematic drinking ~50%

Opoid use ~10%-12%

Illicit drug use ~6%

Suicidal ideation ~10%

## Models

Build predictive models for each of the predictors: 

1. suicidal ideation
2. drug abuse
3. illicit drup use
4. opioid use
5. problematic drinking

Engineer features as necessary, explore possible embeddings. 

Examine predictive features for relative importance.

### Additional analysis

Examine relationship of behaviors to *domains of despair*:

Cognitive despair

Emotional despair

Behavioral despair

Biological despair (allostatic load)

Given a diagnosis are assessment of the domain, does this improve the predictive power of the models?

Machine learning may provide a different way to test, and to determine if despair really related to these behaviors.

## Data Security Protocols

Data protocols are strict. Confidentiality and security must be ensured. IT department has set up server, and users must be approved before being added. Security protocols and agreements can be found here.  

Todd Dotson is the IT consultant. 

## Timeline

Ideally, models be available by the end of the semester, and a paper written by the end of the spring. 

Note: the data has been reviewed, and has passed through a first round of examination and cleaning.

*NOTE*
Subset of data is publicly available. We'll want to consider, for later application of software to the public data. 

A longer-term goal is to provide interactive data and reproducible code.

## Project Logistics
**Sprint planning**: TBD  
**Demos**: Fridays at 2:30pm

**Slack Channel**: TBD  
**Zoom Link**: TBD

**Contact Info**:  
Lauren Gaydosh (PI) 
  + Office: 321 Calhoun Hall
  + Phone: 615-343-7683
  + Email: [lauren.m.gaydosh@vanderbilt.edu](lauren.m.gaydosh@vanderbilt.edu)
  
Jesse Spencer-Smith  
  + Office: Vanderbilt Data Science Institute, Engineering Science Building, Office 315
  + Phone: 615-343-4793 o | 217-377-2867 m
  + Email: [jesse.spencer-smith@vanderbilt.edu](jesse.spencer-smith@vanderbilt.edu)

Charreau Bell  
   + Office: Vanderbilt Data Science Institute, Engineering Science Building, Office 314
   + Phone: 615-343-6626
   + Email: [c.bell@vanderbilt.edu](c.bell@vanderbilt.edu)
