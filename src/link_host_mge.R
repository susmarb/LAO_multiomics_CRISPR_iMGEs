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
host_sp.input <- args[1]
mge.input <- args[2]
output.file <- args[3]

#host_sp.input <- "/mnt/nfs/projects/ecosystem_biology/LAO/time_series/IMP_analysis/LAO_TS/CRISPR_analysis/Mge_TSHost_Link/TS_hosts_sp.tsv"
#mge.input <- "/mnt/nfs/projects/ecosystem_biology/LAO/time_series/IMP_analysis/LAO_TS/CRISPR_analysis/Mge_TSHost_Link/ALL_Spacers_to_PsPCC.tsv"
#output.file <- "/mnt/nfs/projects/ecosystem_biology/LAO/time_series/IMP_analysis/LAO_TS/CRISPR_analysis/CrisprHost/Hosts_PsPCC.tsv"

# spacers of the hosts
host_sp <- read_tsv(host_sp.input)
read_tsv(mge.input) -> mge

# link sp to pspcc-pphage
host_sp %>%
    inner_join(., mge, by = c("reSP" = "spacer")) %>%
    rename(spacer = reSP) -> host_pspcc
write_tsv(host_pspcc, output.file)

