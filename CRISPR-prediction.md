The **CrisprPrediction** module aims the identification and redundancy removal of CRISPR elements, i.e. spacers and repeats, and CRISPR-flanking sequences from preprocessed reads (input of CRASS) and assembled contigs (input of metaCRT), redundancy removal of CRISPR elements, and identification of protospacer-containing contigs.

**Required data**
 - From the results of [IMP](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-1116-8): metagenomic (MG) and metatranscriptomic (MT) preprocessed reads, co-assembled contigs, and MT contigs.  

**Steps** 
 - Run of [CRASS](http://ctskennerton.github.io/crass/) to predict the CRISPR elements from the preprocessed reads, i.e. spacers, repeats, and CRISPR-flanking sequences.
 - Run of [metaCRT](http://omics.informatics.indiana.edu/CRISPR/) to predict the CRISPR elements from the co-assembled and the MT contigs.
 - Custom extraction of CRISPR-flanking sequences from predicted contigs-containing CRISPRs by metaCRT.
 - Removal of redundancy between the CRISPR elements using [CD-HIT](http://weizhongli-lab.org/cd-hit/), in three independent steps:   
    i) Collection of spacers from CRASS and metaCRT predictions, and clustering.  
    ii) Collection and clustering of repeats.  
    iii) Collection and clustering of CRISPR-flanking sequences.  
 - Match by using [BLASTN](https://blast.ncbi.nlm.nih.gov/Blast.cgi) of all the CRISPR elements against the co-assembled contigs.  
 - Based on the BLASTN results, identification of the protospacer-containing contigs(PSCC).  

**Snakemake workflow "CrisprPrediction"**
```
# Source dependencies and define number of threads
source src/preload_modules.sh
THREADS='8'

# Run snakemake (variables defining paths to input files and output directories are in workflows/CrisprPrediction)
snakemake -j $THREADS -pfk crispr_workflow.done -s workflows/CrisprPrediction
```

