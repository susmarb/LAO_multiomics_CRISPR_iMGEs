#!/bin/R

.libPaths("/mnt/gaiagpfs/users/homedirs/smartinezarbas/R/x86_64-pc-linux-gnu-library/3.4")
# path to install/load libraries
packs <- c("tidyr", "dplyr", "readr", "stringr")
for (i in 1:length(packs))
{
  if(packs[i] %in% rownames(installed.packages()) == FALSE)
  {
    install.packages(packs[i], repos="http://cran.univ-paris1.fr/")
  }
  library(packs[i], character.only = TRUE)
}

## Define arguments
args <- commandArgs(TRUE)
pspcc.gff.input <- args[1]
sp.clstr.input <- args[2]
sample2date.input <- args[3]
output.file <- args[4]

#input files
#pspcc.gff.input <- "/mnt/nfs/projects/ecosystem_biology/LAO/time_series/IMP_analysis/LAO_TS/CRISPR_analysis/ALL/protospacers/ALL_pspcc_qcov95_pident95.gff"
#sp.clstr.input <- "/mnt/nfs/projects/ecosystem_biology/LAO/time_series/IMP_analysis/LAO_TS/CRISPR_analysis/ALL/spacers/ReSpa2MeSpa.tsv"
#sample2date.input <- "/mnt/nfs/projects/ecosystem_biology/LAO/time_series/IMP_analysis/LAO_TS/CRISPR_analysis/metadata/sample2date.tsv"
#output.file <- "/mnt/nfs/projects/ecosystem_biology/LAO/time_series/IMP_analysis/LAO_TS/CRISPR_analysis/Mge_TSHost_Link/ALL_Spacers_to_PsPCC.tsv"

### protospacer containing contigs GFF
sample2date <- read_tsv(sample2date.input, col_names = c("sample", "date"))
read_tsv(pspcc.gff.input, col_names = c("pspcc", "tmp0", "tmp1", "start.psp", "end.psp", "evalue","strand.psp", "tmp2", "attribute"), comment = "#") %>%
    separate(attribute, into = c("tmp3", "spacer"), sep = "\"") %>%
    select(-starts_with("tmp"), -evalue) %>% unique() -> pspcc

spacers_cluster <- read_tsv(sp.clstr.input, col_names = c("spacer", "MeSpa"))

pspcc %>% select(spacer, pspcc) %>% unique() %>%
    inner_join(., spacers_cluster, by = "spacer") %>% dplyr::select(spacer, pspcc) %>% unique() -> MeSpa2PsPCC
    #separate(MeSpa, into = c("tool", "type", "sample"), sep = "_", remove = FALSE) %>%
    #select(-tool, -type) %>%
    #inner_join(., sample2date) %>% 
    #select(-sample) %>% unique() -> MeSpa2PsPCC
    
write_tsv(MeSpa2PsPCC, output.file)

## how many targets has each spacer? 
#ReSpa2PsPCC %>% group_by(spacer) %>% count(spacer) %>% rename(target_pspcc = n) -> ALL_RepresentativeSpacers_to_PsPCC_count
#
#ALL_RepresentativeSpacers_to_PsPCC_count.file <- paste0(output.dir, "/ALL_RepresentativeSpacers_to_PsPCC_count.tsv")
#write_tsv(ALL_RepresentativeSpacers_to_PsPCC_count, ALL_RepresentativeSpacers_to_PsPCC_count.file)

## how many targets of the spacer are putative phages?
#MeSpa2PsPCCpphage %>% group_by(spacer) %>% count(spacer) %>% rename(target_pspcc = n) -> ALL_RepresentativeSpacers_to_PsPCC_pphage_count
#
#ALL_RepresentativeSpacers_to_PsPCC_pphage_count.file <- paste0(output.dir, "/ALL_RepresentativeSpacers_to_PsPCC-PutPhage_count.tsv")
#write_tsv(ALL_RepresentativeSpacers_to_PsPCC_pphage_count, ALL_RepresentativeSpacers_to_PsPCC_pphage_count.file)
#
### how many spacers target a single pspcc?
#ReSpa2PsPCC %>% group_by(pspcc) %>% count(pspcc) %>% rename(spacers_targeting = n) -> ALL_PsPCC_targetedByReSpa_count
#ALL_PsPCC_targetedByReSpa_count.file <- paste0(output.dir, "/ALL_PsPCC_targetedByReSpa_count.tsv")
#write_tsv(ALL_PsPCC_targetedByReSpa_count, ALL_PsPCC_targetedByReSpa_count.file)
#
## filter the pspcc by putative phages
#ALL_PsPCC_targetedByReSpa_count %>%
#    filter(pspcc %in% pphages$pspcc) -> ALL_PsPCC_pphage_targetedByReSpa_count
#ALL_PsPCC_pphage_targetedByReSpa_count.file <- paste0(output.dir, "/ALL_PsPCC-PutPhage_targetedByReSpa_count.tsv")
#write_tsv(ALL_PsPCC_pphage_targetedByReSpa_count, ALL_PsPCC_pphage_targetedByReSpa_count.file)
#
