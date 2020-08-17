#!/usr/bin/env Rscript

# Aim: get the coordinates of the flanking regions of the predicted CRISPRs

## Usage: ./script.R metaCRT.out tmp.bed outputTable.tsv

.libPaths("/mnt/gaiagpfs/users/homedirs/smartinezarbas/R/x86_64-pc-linux-gnu-library/3.4")
args = commandArgs(TRUE)
bedNameFile = args[1] # bedNameFile = "Results/flanks.bed"
bedtoolfasNameFile = args[2] # bedtoolfasNameFile = "Results/flankstmp.fa"
tsvseqsNameFile = args[3] # tsvseqsNameFile  = "Results/metacrt_contigs-mgmt_flanks.tsv"

##Reading files 

bed <- read.table(bedNameFile, header = FALSE, sep = "\t", quote = "", stringsAsFactors = FALSE)
fasIn <- readLines(bedtoolfasNameFile)


## Processing fasta file 
ind <- grep(">", fasIn) # Identify header lines
s <- data.frame(ind=ind, from=ind+1, to=c((ind-1)[-1], length(fasIn))) # Identify the sequence lines

# Process sequence lines
seqs <- rep(NA, length(ind))
for(j in 1:length(ind)) 
{
  seqs[j]<-paste(fasIn[s$from[j]:s$to[j]], collapse="")
}

# Create a data frame
fa_df_tmp <- data.frame(merge=gsub(">", "", fasIn[ind]), sequence=seqs, stringsAsFactors = FALSE)

bed$merge <- paste(bed$V1, paste(bed$V2, bed$V3, sep = "-"), sep = ":") 
bed$fullID <- paste(bed$V1, paste(bed$V2, bed$V3, sep = "-"), bed$V4, bed$V5 ,sep = ":")

all <- plyr::join(fa_df_tmp, bed, by = "merge", type = "full")
# dim(all); all[1,]

df_to_print<- cbind.data.frame(all$fullID, all$sequence)
write.table(df_to_print, 
            file = tsvseqsNameFile,
            append = FALSE,
            quote = FALSE,
            row.names = FALSE,
            col.names = FALSE,
            eol = "\n",
            sep="\t")
