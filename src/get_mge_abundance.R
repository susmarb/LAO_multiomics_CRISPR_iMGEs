#!/bin/R
.libPaths("/mnt/gaiagpfs/users/homedirs/smartinezarbas/R/x86_64-pc-linux-gnu-library/3.4")

## instaling/loading packages
packs <- c("tidyr", "dplyr", "tibble",  "stringr", "reshape2", "readr")
for (i in 1:length(packs))
{
  if(packs[i] %in% rownames(installed.packages()) == FALSE) 
  {
    install.packages(packs[i], repos="http://cran.irsn.fr/")
  } 
  library(packs[i], character.only = TRUE)
}

## Define arguments
args <- commandArgs(TRUE)
sample2date.input <- args[1] 
data.dir <- args[2] 
# sample list containing metadata "/scratch/users/smartinezarbas/LAO_TS_CRISPR_ALL/sample_list.tsv"
# directory containing "/scratch/users/smartinezarbas/LAO_TS_CRISPR_ALL/PopulationAnalysisPhage/Calculations/ContigLevel"
table.mg.abab.out <- "ALL_mg_contig_depth.txt"
table.mt.abab.out <- "ALL_mt_contig_depth.txt"

# read metadata and define variable for directory of the calculation files
read_tsv(sample2date.input, col_names = TRUE) %>%
  select(sample = Sample, date = Date) -> sample2date

### Metagenome (MG) ###
# Reading in and joining the MG data
# Data is scattered into different files. Therefore it needs to be first joined (or merged) into a single table.
files <- paste(data.dir, list.files(data.dir), sep="/") %>%
  .[grep(".mg.contig_depth.txt", .)] %>%
  .[!grepl("ALL_m", .)]

  mg <- read_tsv(files[1], col_names = c("contig", files[1]))

for (i in 2:length(files)) {
    mg <- full_join(mg, read_tsv(files[i], col_names = c("contig", files[i])), by="contig")
}


str_split_fixed(colnames(mg)[-1], "/", n=Inf) %>%
  as.tibble() %>%
  dplyr::select(samples = ncol(.)) %>%
  separate(samples, into ="sample", sep="\\.") -> tmp_colnames

colnames(mg)[2:ncol(mg)] <- tmp_colnames$sample
rm(tmp_colnames)

gather(mg, sample, depth, -contig) %>%
  mutate(depth=as.numeric(depth)) %>%
  full_join(., sample2date) %>%
  select(date, contig, depth) %>%
  spread(date, depth) -> mg

write_tsv(mg, paste(data.dir, table.mg.abab.out, sep = "/"))

# Metatranscriptomics
files <- paste(data.dir, list.files(data.dir), sep="/") %>%
  .[grep(".mt.contig_depth.txt", .)] %>%
  .[!grepl("ALL_m", .)]

mt <- read_tsv(files[1], col_names = c("contig", files[1]))

for (i in 2:length(files)) 
{
  mt <- full_join(mt, read_tsv(files[i], col_names = c("contig", files[i])), by="contig")
}

str_split_fixed(colnames(mt)[-1], "/", n=Inf) %>%
  as.tibble() %>%
  dplyr::select(samples = ncol(.)) %>%
  separate(samples, into ="sample", sep="\\.") -> tmp_colnames

colnames(mt)[2:ncol(mt)] <- tmp_colnames$sample
rm(tmp_colnames)

gather(mt, sample, depth, -contig) %>%
  mutate(depth=as.numeric(depth)) %>%
  full_join(., sample2date) %>%
  select(date, contig, depth) %>%
  spread(date, depth) -> mt

write_tsv(mt, paste(data.dir, table.mt.abab.out, sep = "/"))

