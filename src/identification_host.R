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
flblast.input <- args[1]
drblast.input <- args[2]
fl.clstr.input <- args[3]
dr.clstr.input <- args[4]
output.dir <- args[5]
bin2rbin.input <- args[6]

# 
read_tsv(flblast.input) %>%
    separate(sseqid, into = "bin", sep = "_contig_", remove = FALSE) %>%
    filter(ifelse(qlen > 100,  qcovs >= 80, qcovs >= 95), pident >= 95)  -> flblst.bins

flblst.bins.file <- paste0(output.dir, "/ALL_flanks_bins.filtered.blastout")
write_tsv(flblst.bins, flblst.bins.file)

if(args[6] != "NA"){
    bin2rbin <- read_tsv(bin2rbin.input)
    flblst.bins %>%
	inner_join(., bin2rbin, by = "bin") -> flblst.rbins
}else{
    flblst.bins %>%
	rename(rbin = bin) -> flblst.rbins
}

## link flank with the repeats 
fl.clstr <- read_tsv(fl.clstr.input, col_names = c("cluster", "reFL", "memberFL", "length", "binary_member"))
dr.clstr <- read_tsv(dr.clstr.input, col_names = c("cluster", "reDR", "memberDR", "length", "binary_member"))


dr.clstr %>%
    separate(memberDR, into = c("id.meta"), sep = ":p", remove = FALSE) %>%
    separate(id.meta, into = c("tmp", "id.meta"), sep = "mt_") %>% 
    separate(memberDR, into = c("id.crass"), sep = "DR", remove = FALSE) %>%
    mutate(id = ifelse(grepl("meta", memberDR), id.meta, id.crass)) %>%
    select(id, reDR, memberDR) %>% unique() -> DRid

fl.clstr %>%
    separate(memberFL, into = c("id.crass"), sep = "FL", remove = FALSE) %>%
    separate(memberFL, into = c("meta", "position", "stream", "n"), sep = ":", remove = FALSE) %>%
    mutate(n = ifelse(n == "1c", "c1", ifelse(n == "2c", "c2", ifelse(n == "3c", "c3", n)))) %>%
    mutate(id.meta = paste(meta,n, sep = ":")) %>%
    mutate(id = ifelse(grepl("crass", memberFL), id.crass, id.meta)) %>%
    select(id, reFL, memberFL) %>% unique() -> FLid

# merge flanks and repeats, and filter repeats with no enough identity and coverage
read_tsv(drblast.input) %>%
        filter(qcovs >= 80, pident >= 75) -> drblast.bins
drblast.bins.file <- paste0(output.dir, "/ALL_repeats_bins.filtered.blastout")
write_tsv(drblast.bins, drblast.bins.file)

flblst.rbins %>%
    rename(reFL = qseqid) %>%
    inner_join(., FLid) %>%
    inner_join(., DRid) %>% na.omit() %>%
    select(rbin, reFL, reDR, memberDR) %>% unique() %>%
    inner_join(., drblast.bins, by = c("reDR" = "qseqid")) %>%
    select(rbin, reFL, reDR, memberDR) %>% unique() -> ts_hosts

ts_hosts.file <- paste0(output.dir, "/Hosts_FLDR4SP.tsv")
write_tsv(ts_hosts, ts_hosts.file)

# save bins and their non-redundant flanks and repeats
ts_hosts %>%
	select(rbin, reFL, reDR) %>% unique() %>% arrange(rbin) %>%
	write_tsv(., paste0(output.dir, "/Hosts_FLDR.tsv"))
