#!/usr/bin/env Rscript

# Aim: get the coordinates of the flanking regions of the predicted CRISPRs

## Usage: ./script.R metaCRT.out tmp.bed
.libPaths("/mnt/gaiagpfs/users/homedirs/smartinezarbas/R/x86_64-pc-linux-gnu-library/3.4")
args = commandArgs(TRUE)
metaNameFile = args[1]
tmpbed = args[2]

file.create(c(tmpbed), showWarnings = FALSE)

# reading file
meta <- readLines(metaNameFile)

# getting indices of the entries
indices <- grep("^SEQ:*", meta)
  # length(indices)

# parsing every entry

for (i in 1:length(indices))
{
  # print(sprintf("Parsing entry: %s. %d out of %d", meta[indices[i]], i, length(indices)))
  
  # Extracting all the lines of every entry to parse:
    # Contig ID
    # Size of the contig
    # Number of CRISPRs predicted within the contig
    # Positions of the CRISPRs within the contig
  
  if (is.na(indices[i+1]) == FALSE)
  {
    # extracting info in every entry except the last one
    lines_to_subset <- indices[i]:(indices[i+1]-3)
    lines <- meta[lines_to_subset]
    
  }else{
    # extracting info in last entry
    lines_to_subset <- indices[i]:(length(meta)-6)
    lines <- meta[lines_to_subset]
  }
  
    L_df <- as.data.frame(lines)
    
    contigID <- unlist(strsplit(as.character(L_df[1,1]), " "))[2]
    sizeContig <- as.numeric(unlist(strsplit(as.character(L_df[2,1]), " "))[2])
    nCs <-as.numeric(unlist(strsplit(as.character(L_df[3,1]), " "))[3])
    Cs <- paste(nCs, "c", sep = "")
    range_v <- as.numeric(unlist(strsplit(as.character(L_df[6,1]), " "))[c(6,8)])
    
    # Parse only CRISPRs detected in contigs whose size is above 500 bp
    if(sizeContig > 500)
    {
      # print(sprintf("Number of CRISPRs detected: %d", nCs))
      
      # One CRISPR predicted
      if(nCs == 1)
      {
        # U flank, if the CRISPR element starts after the 50th position
        if (range_v[1] > 50)
        {
          #print(i)
          U <- data.frame(Contig_ID=contigID, Start=0, End=range_v[1], Flank="U", nCRISPR=Cs)
          write.table(U, file=tmpbed, append = TRUE, quote=FALSE, row.names = FALSE, col.names = FALSE, eol = "\n", sep="\t")
          
        }
        # D flank, if there is at least 50 remaining bps in the contig after the CRISPR element ends
        if (sizeContig - range_v[2] > 50)
        {
          #print(i)
          D <- data.frame(Contig_ID=contigID, Start=range_v[2]-1, End=sizeContig, Flank="D", nCRISPR=Cs)
          write.table(D, file=tmpbed, append = TRUE, quote=FALSE, row.names = FALSE, col.names = FALSE, eol = "\n", sep="\t")
          
        }
      }else{
        if (nCs >= 2)
        {
        # print(sprintf("Number of CRISPRs detected: %d", nCs))
        # print(i)
          indices_multiCrisprs <- grep("^CRISPR*", L_df[,1])
          # ifnCs == length(indices_multiCrisprs)
          
          # the flanking regions will be
            # U flank (1, start position of the first CRISPR)
            # D flank (end position of the last CRISPR, end of the contig)
            
          # Extraction of the firt and last CRISPRs sequence ranges
          range_crispr1 <- as.numeric(unlist(strsplit(as.character(L_df[indices_multiCrisprs[1],1]), " "))[c(6,8)])
          range_crisprLast <- as.numeric(unlist(strsplit(as.character(L_df[indices_multiCrisprs[length(indices_multiCrisprs)],1]), " "))[c(6,8)])
            
          if (range_crispr1[1] > 50)
          {
            #print(i)
            U <- data.frame(Contig_ID=contigID, Start=1, End=range_crispr1[1], Flank="U", nCRISPR=Cs)
            write.table(U, file=tmpbed, append = TRUE, quote=FALSE, row.names = FALSE, col.names = FALSE, eol = "\n", sep="\t")
            
          }
          # D flank, if there is at least 50 remaining bps in the contig after the CRISPR element ends
          if (sizeContig - range_crisprLast[2] > 50)
          {
            #print(i)
            D <- data.frame(Contig_ID=contigID, Start=range_crisprLast[2], End=sizeContig, Flank="D", nCRISPR=Cs)
            write.table(D, file=tmpbed, append = TRUE, quote=FALSE, row.names = FALSE, col.names = FALSE, eol = "\n", sep="\t")
            
          }
        }
      }
      
    }else{
      # print("Discarded, size below 500 bp")
    }
}
