library("seqinr")

data <- c(">Rosetta_Example_1","THERECANBENOSPACE",">Rosetta_Example_2","THERECANBESEVERAL","LINESBUTTHEYALLMUST","BECONCATENATED")
fname <- "rosettacode.fasta"
f <- file(fname,"w+")
writeLines(data,f)
close(f)

fasta <- read.fasta(file = fname, as.string = TRUE, seqtype = "AA")
for (aline in fasta) {
  cat(attr(aline, 'Annot'), ":", aline, "\n")
}
