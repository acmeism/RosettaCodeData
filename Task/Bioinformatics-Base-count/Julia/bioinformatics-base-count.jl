const sequence =
"CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG" *
"CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG" *
"AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT" *
"GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT" *
"CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG" *
"TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA" *
"TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT" *
"CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG" *
"TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC" *
"GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT"

function dnasequenceprettyprint(seq, colsize=50)
    println(length(seq), "nt DNA sequence:\n")
    rows = [seq[i:min(length(seq), i + colsize - 1)] for i in 1:colsize:length(seq)]
    for (i, r) in enumerate(rows)
        println(lpad(colsize * (i - 1), 5), "   ", r)
    end
end

dnasequenceprettyprint(sequence)

function printcounts(seq)
    bases = [['A', 0], ['C', 0], ['G', 0], ['T', 0]]
    for c in seq, base in bases
        if c == base[1]
            base[2] += 1
        end
    end
    println("\nNucleotide counts:\n")
    for base in bases
        println(lpad(base[1], 10), lpad(string(base[2]), 12))
    end
    println(lpad("Other", 10), lpad(string(length(seq) - sum(x[2] for x in bases)), 12))
    println("     _________________\n", lpad("Total", 10), lpad(string(length(seq)), 12))

end

printcounts(sequence)
