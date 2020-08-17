#!/usr/bin/env Rscript

## Generate GFF for the protospacer containing contigs

# parameters
args = commandArgs(TRUE)
pspcc.blast.input = args[1]
file2save = args[2]
# pspcc.blast.input <- "/scratch/users/smartinezarbas/LAO_TS_CRISPR_ALL/ALL/protospacers/ALL_protospacer-merged_x_ALL_MGMT.assembly.merged-filtered_pid85_cov85.tsv"
# file2save <- "/scratch/users/smartinezarbas/LAO_TS_CRISPR_ALL/ALL/protospacers/ALL_pspcc_qcov95_pident95.gff"

## instaling/loading packages
library2install <- "/mnt/gaiagpfs/users/homedirs/smartinezarbas/R/x86_64-pc-linux-gnu-library/3.4/"
packs <- c("tidyr", "dplyr", "tibble", "readr")

for (i in 1:length(packs))
{
    library(packs[i], character.only = TRUE, lib.loc=library2install)
}

# read table
pspcc.blast <- read_tsv(pspcc.blast.input)

# prepare gff table for spacers (contigs with sp and dr matches)
pspcc.blast %>%
    mutate(strand = ifelse(sstart - send < 0, "+", "-")) %>%
    mutate(source = ".", type = "CRISPR", frame = ".") %>%
    mutate(attribute = paste(paste("spacer_ID=", "\"", qseqid, "\"", sep = ""), paste(), sep = ";")) %>%
    mutate(start = ifelse(sstart<send, sstart, send), end = ifelse(send<sstart, sstart, send)) %>%
    select(sseqid, source, type, start, end, evalue, strand, frame, attribute) %>%
    unique() -> pspcc
write.table("##gff-version 3.2.1", file2save, quote = FALSE, col.names = FALSE, row.names = FALSE, sep = "\t")
write.table(pspcc, file2save, quote = FALSE, col.names = FALSE, row.names = FALSE, sep = "\t", append = TRUE)

