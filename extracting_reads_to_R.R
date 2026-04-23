library(Rsamtools)

#over here when you reference the range you want to use, remember to use the chromosome ref name
#that can be found using samtools and looking at the seqinfo, and it is usually also found in the logs made when creating the bam file
which <- GRanges(c(
  "NZ_CP156019.1:100-1000"
))

what <- c("rname", "pos")

param <- ScanBamParam(which=which, what=what)

bamFile <- "/home/mohamed-g/RNA_personal_project/aligned_reads/Aligned.out.sorted.bam"
bamIndex <- "/home/mohamed-g/RNA_personal_project/aligned_reads/Aligned.out.sorted.bam.bai"
#I was having issues with system.file(), so I decided to just pass on the bamfile name and the bamindex name
#... to scanBam directly

bam <- scanBam(bamFile, index = bamIndex, param=param)
#if I want to access the bam file I just loaded, I have to call on "bam" as if it is a list, because it is a list of lists
#the next step to work with all of this data is to basically convert it to dataframes so I can use it using dplyr and other
#R packages...
