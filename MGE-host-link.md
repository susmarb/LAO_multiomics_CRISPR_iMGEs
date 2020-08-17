The **MgeHostLink** module aims the assignment of CRISPR elements from the entire time-series to the hosts, and the identification of the links between iMGE sequences, i.e. plasmid , phages and PSCCs, to such hosts via CRISPR information.

**Required data**
 - From the current overall pipeline: fasta file of repeats and CRISPR-flanking sequences, information of the CRISPR elements' clusters.  
 - From IMP-derived downstream analyses: representative genomes from the dereplication of the time-series bins.  

**Steps** 
 - Blast of representative genomes (putative hosts) against CRISPR-flanking sequences.  
 - Blast of representative genomes (putative hosts) against repeats.  
 - Assignement of spacers from the time-series to specific hosts:  
 i) Filter hosts by matches with repeat and CRISPR-flanking sequences: based on coverage and identity.  
 ii) Assignment of spacers to hosts.  
 - Link of iMGEs to hosts:  
 i) Link spacers to protospacers: from matches between spacers and co-assembled contigs, and prediction of iMGEs. Resulting in links between iMGEs and hosts.

**Snakemake workflow "CrisprPrediction"**
```
# Source dependencies and define number of threads
source src/preload_modules.sh
THREADS='8'

# Run snakemake (variables defining paths to input files and output directories are in workflows/MgeHostLink)
snakemake -npf mge_host_link_workflow.done -s workflows/MgeHostLink
```