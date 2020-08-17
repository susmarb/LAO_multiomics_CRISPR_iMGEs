#!/bin/R
.libPaths("/mnt/gaiagpfs/users/homedirs/smartinezarbas/R/x86_64-pc-linux-gnu-library/3.4")
library(stringr)

### Define arguments
args <- commandArgs(TRUE)
# Spacer blast input
spacer.input <- args[1]
# Repeat blast input
repeat.input <- args[2]

# Protospacer table full output
pspcr.output <- args[3]
# Protospacer table reduced (85% identity and 85% coverage) output
pspcr.output_reduced <- args[4]

### Read in input
spacer.res <- read.table(spacer.input, header=T, stringsAsFactors=F)
repeat.res <- read.table(repeat.input, header=T, stringsAsFactors=F)

# Remove contigs that contain CRISPR repeat matches
#head(spacer.res$qseqid)

#crispr_contigs <- unique(str_split_fixed(str_split_fixed(spacer.res$qseqid, "_", 3)[,3], ":", 2)[,1])
#crispr_contigs <- crispr_contigs[-grep("Cov", crispr_contigs)]
#crispr_contigs <- crispr_contigs[-grep("_k99_", crispr_contigs)]

pspcr.res <- spacer.res[-c(which(spacer.res$sseqid%in%unique(repeat.res$sseqid))),]
#pspcr.res <- pspcr.res[-c(which(pspcr.res$sseqid%in%crispr_contigs)),]

# Remove hits below 85% identity and 85% query coverage
pspcr.res_reduced <- subset(pspcr.res, pident >= 95 & qcovs >= 95)

### Write output
write.table(pspcr.res, pspcr.output, row.names=F, sep="\t", quote=F)
write.table(pspcr.res_reduced, pspcr.output_reduced, row.names=F, sep="\t", quote=F)
