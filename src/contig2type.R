#!/bin/R
.libPaths("/mnt/gaiagpfs/users/homedirs/smartinezarbas/R/x86_64-pc-linux-gnu-library/3.4/")

## generate a table with the classification of the pspcc

# Usage: Rscript ##TBadded
# define arguments
args <- commandArgs(TRUE)
pspcc.input <- args[1]
plsmds.plasflow.input <- args[2]
plsmds.cBar.input <- args[3]
virfinder.input <- args[4]
virsorter.input <- args[5]
file2saveContigs <- args[6]
virsorter.dir <- args[7]
virfinder.dir <- args[8]

#pspcc.input <- "/mnt/nfs/projects/ecosystem_biology/LAO/time_series/IMP_analysis/LAO_TS/CRISPR_analysis/PlasmidPhageDereplication/ALL_protspacer_id_contigs.txt"
#plsmds.cBar.input <- "/mnt/nfs/projects/ecosystem_biology/LAO/time_series/IMP_analysis/LAO_TS/CRISPR_analysis/PhagePlasmidPrediction/cBar/ALL_mgmt_cBar_plasmids.txt"
#plsmds.plasflow.input <- "/mnt/nfs/projects/ecosystem_biology/LAO/time_series/IMP_analysis/LAO_TS/CRISPR_analysis/PhagePlasmidPrediction/PlasFlow/ALL_mgmt_plasflow_plasmids.txt"
#virfinder.input <- "/mnt/nfs/projects/ecosystem_biology/LAO/time_series/IMP_analysis/LAO_TS/CRISPR_analysis/PlasmidPhageDereplication/ALL_VirFinder_id_contigs.txt"
#virsorter.input <- "/mnt/nfs/projects/ecosystem_biology/LAO/time_series/IMP_analysis/LAO_TS/CRISPR_analysis/PlasmidPhageDereplication/ALL_VIRSorter_id_contigs.txt"
#file2saveContigs <- "/mnt/nfs/projects/ecosystem_biology/LAO/time_series/IMP_analysis/LAO_TS/CRISPR_analysis/PlasmidPhageDereplication/ALL_contigs_class.tsv"
#virsorter.dir <- "/mnt/nfs/projects/ecosystem_biology/LAO/time_series/IMP_analysis/LAO_TS/CRISPR_analysis/PhagePlasmidPrediction/VirSorter"
#virfinder.dir <- "/mnt/nfs/projects/ecosystem_biology/LAO/time_series/IMP_analysis/LAO_TS/CRISPR_analysis/PhagePlasmidPrediction/VirFinder"

## installing/loading packages
packs <- c("tidyr", "dplyr", "tibble", "readr")
for (i in 1:length(packs))
{
     if(packs[i] %in% rownames(installed.packages()) == FALSE)
	{
	    install.packages(packs[i], repos="http://cran.irsn.fr/")
	}
    library(packs[i], character.only = TRUE)
}
# read  lists of contigs by predicted classification
pspcc.ids <- read.table(pspcc.input, stringsAsFactors = FALSE, header = FALSE, sep = "\t"); colnames(pspcc.ids) <- c("contig")
plsmds.plasflow.ids <- read.table(plsmds.plasflow.input, stringsAsFactors = FALSE, header = FALSE, sep = "\t"); colnames(plsmds.plasflow.ids) <- c("contig")
plsmds.cBar.ids <- read.table(plsmds.cBar.input, stringsAsFactors = FALSE, header = FALSE, sep = "\t"); colnames(plsmds.cBar.ids) <- c("contig")
virfinder.ids <- read.table(virfinder.input, stringsAsFactors = FALSE, header = FALSE, sep = "\t"); colnames(virfinder.ids) <- c("contig")
virsorter.ids <- read.table(virsorter.input, stringsAsFactors = FALSE, header = FALSE, sep = "\t"); colnames(virsorter.ids) <- c("contig")

# merge tables
pspcc.ids$pspcc <- 1
plsmds.plasflow.ids$plasflow <- 1
plsmds.cBar.ids$cBar <- 1
virfinder.ids$virfinder <- 1
virsorter.ids$virsorter <- 1

pspcc.ids %>%
    dplyr::full_join(., virsorter.ids) %>%
    dplyr::full_join(., virfinder.ids) %>%
    dplyr::full_join(., plsmds.plasflow.ids) %>%
    dplyr::full_join(., plsmds.cBar.ids) %>%
    replace_na(list(pspcc = 0, plasflow = 0, cBar = 0, virsorter = 0, virfinder = 0))  -> contigs.class


# Add VirSorter category and number of hallmark genes detected
samples <- list.dirs(virsorter.dir, recursive = FALSE); samples[-1] -> samples

for (i in 1:length(samples))
{
    file2read <- paste(samples[i], "VIRSorter_global-phage-signal.csv", sep = "/")
    read_delim(file2read, delim = ",", col_names = c("Contig_id", "Nb_genes_contigs", "Fragment", "Nb_genes", "Category", "Nb_phage_hallmark_genes", "Phage_gene_enrichment_sig", "Non-Caudovirales_phage_gene_enrichment_sig", "Pfam_depletion_sig", "Uncharacterized_enrichment_sig", "Strand_switch_depletion_sig", "Short_genes_enrichment_sig"), comment = "#") %>% 
	select(Contig_id, Nb_genes, Nb_phage_hallmark_genes, Category) %>%
	separate(Contig_id, into = c("contig", "circular"), sep = "-") %>%
	mutate(circular = ifelse(is.na(circular), 0, 1)) %>%
	separate(contig, into = c("hola", "contig"), sep = "VIRSorter_") %>% select(-hola) %>%
	mutate(prophage = ifelse(Category == 4 | Category == 5 | Category == 6, 1, 0)) -> virsorter_tmp
    ifelse(i == 1, virsorter <-  virsorter_tmp, virsorter <- rbind(virsorter, virsorter_tmp))
}
virsorter  %>% filter(contig %in% contigs.class$contig) -> virS
contigs.class %>% left_join(., virS, by = "contig") -> contigs.class

# Add VirFinder p-value
samples <- list.dirs(virfinder.dir, recursive = FALSE); samples[c(-3,-55)] -> samples

for (i in 1:length(samples))
{
	file2read <- paste(samples[i], "VirFinder_predicted_phages_mgmt_all.tsv", sep = "/")
	read_tsv(file2read, col_names = c("contig", "length", "score", "pvalue_virFinder")) %>%
	filter(pvalue_virFinder < 0.05) %>% filter(!grepl("_S", contig)) -> virfinder_tmp

    ifelse(i == 1, virfinder <- virfinder_tmp, virfinder <- rbind(virfinder, virfinder_tmp))
}
virfinder %>% select(., -length, -score) %>% filter(contig %in% contigs.class$contig) %>% unique() -> virF

contigs.class %>% left_join(., virF, by = "contig") -> contigs.class

write_tsv(contigs.class, file2saveContigs)

