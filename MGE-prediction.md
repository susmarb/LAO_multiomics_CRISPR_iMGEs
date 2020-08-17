The **MgePrediction** module aims the identification/prediction of bacteriophage and plasmid sequences from assembled contigs.
 
**Required data**
 - From the results of [IMP](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-1116-8): co-assembled contigs, and MT contigs.  
**Steps**  
 - Prediction of **phages** by [VirSorter](https://github.com/simroux/VirSorter) and [VirFinder](https://github.com/jessieren/VirFinder).  
 - Prediction of **plasmids** by [cBar](http://csbl.bmb.uga.edu/~ffzhou/cBar/) and [PlasFlow](https://github.com/smaegol/PlasFlow).  

**Snakemake workflow "MgePrediction"** 
```
# Source dependencies and define number of threads
source /home/users/smartinezarbas/git/gitlab/CRISPR_MGE_pipeline/src/preload_modules.sh
export THREADS='8'

# Run snakemake (variables defining paths to input files and output directories are in workflows/MgePrediction)
snakemake -j $THREADS -pf plasmid_phage_prediction_workflow.done -s workflows/MgePrediction
```
