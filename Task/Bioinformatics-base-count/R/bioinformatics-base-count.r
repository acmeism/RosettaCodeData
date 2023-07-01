#Data
gene1 <- "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG
CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG
AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT
GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT
CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG
TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA
TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT
CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG
TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC
GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT"

#Analysis:
gene2 <- gsub("\n", "", gene1) #remove \n chars
gene3 <- strsplit(gene2, split = character(0)) #split into list
gene4 <- gene3[[1]] #pull out character vector from list
basecounts <- as.data.frame(table(gene4)) #make table of base counts

#quick helper function to print table results
print_row <- function(df, row){paste0(df$gene[row],": ", df$Freq[row])}

#Print Function for Data with Results:
cat(" Data: \n",
    "  1:",substring(gene2, 1, 50),"\n",
    " 51:",substring(gene2, 51, 100),"\n",
    "101:",substring(gene2, 101, 150),"\n",
    "151:",substring(gene2, 151, 200),"\n",
    "201:",substring(gene2, 201, 250),"\n",
    "251:",substring(gene2, 251, 300),"\n",
    "301:",substring(gene2, 301, 350),"\n",
    "351:",substring(gene2, 351, 400),"\n",
    "401:",substring(gene2, 401, 450),"\n",
    "451:",substring(gene2, 451, 500),"\n",
    "\n",
    "Base Count Results: \n",
    print_row(basecounts,1), "\n",
    print_row(basecounts,2), "\n",
    print_row(basecounts,3), "\n",
    print_row(basecounts,4), "\n",
    "\n",
    "Total Base Count:", paste(length(gene4))
    )
