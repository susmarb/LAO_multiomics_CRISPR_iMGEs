#!/bin/R

.libPaths("/mnt/gaiagpfs/users/homedirs/smartinezarbas/R/x86_64-pc-linux-gnu-library/3.4")

## instaling/loading packages
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
host.input <- args[1]
sp.clstr.input <- args[2]
output.file <- args[3]

# repeats of the hosts
host <- read_tsv(host.input)
host %>%
    separate(memberDR, into = c("id.meta"), sep = ":p", remove = FALSE) %>%
    separate(memberDR, into = c("id.crass"), sep = "DR", remove = FALSE) %>%
    mutate(id = ifelse(grepl("meta", memberDR), id.meta, id.crass)) %>%
    select(rbin, id) %>% unique() -> DRid

## spacers 
read_tsv(sp.clstr.input, col_names = c("cluster", "reSP", "memberSP", "length", "binary_member")) -> sp.clstr

sp.clstr %>%
    separate(memberSP, into = c("id.meta"), sep = ":p", remove = FALSE) %>%
    separate(memberSP, into = c("id.crass"), sep = "SP", remove = FALSE) %>%
    mutate(id = ifelse(grepl("meta", memberSP), id.meta, id.crass)) %>%
    select(reSP, memberSP, id) %>%
    inner_join(., DRid) %>% select(-id, -memberSP) %>% unique() -> host_sp

write_tsv(host_sp, output.file)

