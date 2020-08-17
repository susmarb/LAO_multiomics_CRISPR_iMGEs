#!/usr/bin/env Rscript

## Usage ./Rscript arg1=fasta.input arg2=name-output_file_no_filtered_predictions arg3=name-output_file_filtered_predictions


## path of the libraries
#.libPaths("/mnt/gaiagpfs/users/homedirs/smartinezarbas/R/x86_64-pc-linux-gnu-library/3.4/")
.libPaths("/mnt/nfs/projects/ecosystem_biology/local_tools/VirFinder/R_3.4.0-intel")

## install and/or load packages
packs_0 <- c("tidyr", "dplyr", "tibble", "readr", "glmnet", "Rcpp")
packs_1 <- "qvalue"
pack_virfinder <- "VirFinder"
packs <- c(packs_0, packs_1, pack_virfinder)

for (i in 1:length(packs_0))
{
    if(packs_0[i] %in% rownames(installed.packages()) == FALSE){
      install.packages(packs[i], repos="http://cran.irsn.fr/")}   
}
for (i in 1:length(packs_1))
{
      if(packs_1[i] %in% rownames(installed.packages()) == FALSE){
      source("https://bioconductor.org/biocLite.R")
      biocLite(packs_1[i])}

}
if(pack_virfinder %in% rownames(installed.packages()) == FALSE){
install.packages("/work/users/smartinezarbas/Downloads/VirFinder_1.1.tar.gz", repos = NULL, type="source")
}

for (i in 1:length(packs)){
library(packs[i], character.only = TRUE)
}

## define arguments
args <- commandArgs(TRUE)
fast.input <- args[1]
prediction.output <- args[2]
prediction_pvalue005_noshorts.output <- args[3]
prediction_pvalue001.output <- args[4]


# running virfinder
predResult <- VF.pred(fast.input)

# saving the redictions
predResult %>% 
  write.table(., file = prediction.output, append = TRUE, quote = FALSE, sep = "\t", eol = "\n", row.names = FALSE, col.names = FALSE)
  
predResult %>% 
    filter(!grepl("_S", name)) %>% #filter of the short contigs (length < 1000)
    filter(pvalue < 0.05) %>% 
    write.table(., file = prediction_pvalue005_noshorts.output, append = TRUE, quote = FALSE, sep = "\t", eol = "\n", row.names = FALSE, col.names = FALSE)

predResult %>%
    filter(pvalue < 0.01) %>%
    write.table(., file = prediction_pvalue001.output, append = TRUE, quote = FALSE, sep = "\t", eol = "\n", row.names = FALSE, col.names = FALSE)
