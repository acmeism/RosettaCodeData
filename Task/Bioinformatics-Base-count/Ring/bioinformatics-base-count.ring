dna = "" +
      "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG" +
      "CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG" +
      "AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT" +
      "GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT" +
      "CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG" +
      "TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA" +
      "TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT" +
      "CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG" +
      "TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC" +
      "GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT"

dnaBase = [:A=0, :C=0, :G=0, :T=0]
lenDna = len(dna)
for n = 1 to lenDna
    dnaStr = substr(dna,n,1)
    switch dnaStr
           on "A"
              strA = dnaBase["A"]
              strA++
              dnaBase["A"] = strA
           on "C"
              strC = dnaBase["C"]
              strC++
              dnaBase["C"] = strC
           on "G"
              strG = dnaBase["G"]
              strG++
              dnaBase["G"] = strG
           on "T"
              strT = dnaBase["T"]
              strT++
              dnaBase["T"] = strT
     off
next
? "A : " + dnaBase["A"]
? "T : " + dnaBase["T"]
? "C : " + dnaBase["C"]
? "G : " + dnaBase["G"]
