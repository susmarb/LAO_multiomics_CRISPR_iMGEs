IMP_ENV=/mnt/nfs/projects/ecosystem_biology/local_tools/IMP/dependencies

#export PATH=$IMP_ENV/fastuniq/source:$PATH
#export PATH=$IMP_ENV/sortmerna-2.0:$PATH
#export PATH=$IMP_ENV/sortmerna-2.0/scripts:$PATH
export PATH=$IMP_ENV/bwa-0.7.9a:$PATH
#export PATH=$IMP_ENV/idba-1.1.1/bin:$PATH
#export PATH=$IMP_ENV/megahit:$PATH
#export PATH=$IMP_ENV/CAqP3:$PATH
export PATH=$IMP_ENV/prokka/bin:$PATH
#export PATH=$IMP_ENV/quast:$PATH
#export PATH=$IMP_ENV/quast/libs/genemark/linux_64:$PATH
export PATH=$IMP_ENV/prokka/binaries/linux:$PATH
export PATH=$IMP_ENV/cd-hit-v4.6.1-2012-08-27_OpenMP:$PATH
export PATH=$PATH:/mnt/nfs/projects/ecosystem_biology/local_tools/cd-hit-auxtools-v0.5-2012-03-07

# Samtools must be full path!
export PATH=/mnt/nfs/projects/ecosystem_biology/local_tools/IMP/dependencies/samtools-0.1.19:$PATH
export PATH=/mnt/nfs/projects/ecosystem_biology/local_tools/IMP/dependencies/bedtools2/bin:$PATH
export PATH=$PATH:/mnt/nfs/projects/ecosystem_biology/local_tools/IMP/dependencies/bedtools2/bin
export PATH=$PATH:$IMP_ENV/bedtools2/bin

# genome tools
export PATH=$PATH:/mnt/nfs/projects/ecosystem_biology/local_tools/genometools/bin

#source this file before execution of snakefile
source /mnt/nfs/projects/ecosystem_biology/local_tools/IMP/bin/activate
module load lang/Java/1.8.0_121

export PERL5LIB=$PERL5LIB:/mnt/nfs/projects/ecosystem_biology/local_tools/vcftools/perl
export PATH=$PATH:/mnt/nfs/projects/ecosystem_biology/local_tools/Platypus/Platypus_0.8.1
export PATH=/mnt/nfs/projects/ecosystem_biology/local_tools/IMP/dependencies/KronaTools-2.5/bin:$PATH
export PATH=$PATH:/mnt/nfs/projects/ecosystem_biology/local_tools/FastQC
export PATH=$PATH:/home/users/claczny/apps/software/pullseq/bin

#featureCounts
export PATH=$PATH:/mnt/nfs/projects/ecosystem_biology/local_tools/subread-1.5.1-Linux-x86_64/bin


#module load lang/R/3.4.0-intel-2017a-X11-20170314-bare


# plasflow
export PATH=$PATH:/mnt/nfs/projects/ecosystem_biology/local_tools/PlasFlow/plasflow_env/bin
## CRISPR programs
module load lib/zlib/1.2.11
#export PATH=/mnt/nfs/projects/ecosystem_biology/local_tools/metaCRT:$PATH
#export PATH=/home/users/smartinezarbas/bin/metaCRT:$PATH
export PATH=/mnt/nfs/projects/ecosystem_biology/local_tools/crass_crispr/bin:$PATH
export PATH=$PATH:/mnt/nfs/projects/ecosystem_biology/local_tools/Maven/apache-maven-3.3.9/genometools/bin

# Set up the environment
#module load lang/R/3.4.0-intel-2017a-X11-20170314-bare

#module load bio/HMMER
#module load bio/HMMER/3.1b2-ictce-7.3.5
module load tools/bzip2
module load bio/BLAST/2.2.26-Linux_x86_64

# CoNet
export PATH=$PATH:/mnt/nfs/projects/ecosystem_biology/local_tools/CoNet


