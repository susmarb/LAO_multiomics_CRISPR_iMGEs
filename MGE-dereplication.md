The **MgeDereplication** module aims the redundancy removal of previously identified/predicted iMGEs, i.e. plasmids, bacteriophages, and protospacer-containing contigs (PSCC).

**Required data**
 - Results of VirFinder, VirSorter, cBar, and PlasFlow tools.  

**Steps** 
 - Collecti all the identifiers of the predicted plasmid and phage sequences, and the PSCCs. Hereafter referred to as invasive mobile genetic elements (iMGEs).  
 - Make fasta file with all iMGEs.  
 - Run [CD-HIT](http://weizhongli-lab.org/cd-hit/) to cluster the iMGE sequences.
 - Generate table of iMGE information: identifier/contig, prediction results, iMGE type , ...)
 
**Snakemake workflow "CrisprPrediction"**
```
# Source dependencies and define number of threads
source src/preload_modules.sh
THREADS='8'

# Run snakemake (variables defining paths to input files and output directories are in workflows/MgePrediction)
snakemake -j 8 -pf mge_dereplication_workflow.done -s workflows/MgePrediction
```