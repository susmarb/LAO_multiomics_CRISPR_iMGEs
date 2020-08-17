#!/bin/R
.libPaths("/mnt/gaiagpfs/users/homedirs/smartinezarbas/R/x86_64-pc-linux-gnu-library/3.4")

# loading packages
packs <- c("tidyr", "dplyr", "tibble", "readr")
for (i in 1:length(packs)){library(packs[i], character.only = TRUE)}

# define arguments
args <- commandArgs(TRUE)
sp2date.input <- args[1]
sp2pspcc.input <- args[2]
pspcc_type.input <- args[3]
sp2type.output <- args[4]

read_tsv(sp2date.input, col_names = T) %>%
    rename(spacer = reSP) -> sp2date

read_tsv(sp2pspcc.input, col_names = TRUE) %>%
    rename(contig = pspcc) %>% unique() -> sp2pspcc

pspcc_type <- read_tsv(pspcc_type.input, col_names = TRUE)

full_join(sp2date, sp2pspcc) %>%
    left_join(., pspcc_type) %>%
    mutate(target = ifelse(is.na(contig), 0, 1)) %>%
    replace(is.na(.), 0) %>%
    select(spacer,target,contig,pspcc,virsorter,virfinder,plasflow,cBar) %>% unique() -> sp2type

write_tsv(sp2type, sp2type.output)

