The **MgeRemapping** aims the mapping of the metagenomic and metatranscriptomic reads to the iMGE sequences.

**Required data**
 - From the results of IMP: metagenomic (MG) and metatranscriptomic (MT) preprocessed reads.  
 - From the [MgeDereplication](MGE-dereplication.md) module, the list of unique iMGEs, and its corresponding fasta file.  
 
**Steps** 
 - Collect annotation of the sequences in GFF from IMP.  
 - Create index of the iMGE sequences for [bwa](https://icb.med.cornell.edu/wiki/index.php/Elementolab/BWA_tutorial).   
 - Map reads to the iMGE contigs.  
 - Run [bedtools](https://bedtools.readthedocs.io/en/latest/) and [featureCounts](http://bioinf.wehi.edu.au/subread-package/).    
 - Estimate abundance and expression of the iMGEs, based on the average depth of coverage per contig.

**Snakemake workflow "*MgeRemapping"**
```
# Source dependencies and define number of threads
source src/preload_modules.sh
THREADS='4'

# Run snakemake (variables defining paths to input files and output directories are in workflows/MgeRemapping)
snakemake -j $THREADS -pfk mge_remapping_workflow.done -s workflows/MgeRemapping
```