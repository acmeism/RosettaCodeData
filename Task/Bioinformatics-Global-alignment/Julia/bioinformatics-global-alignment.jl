using Combinatorics

""" Given a DNA sequence, report the sequence, length and base counts"""
function printcounts(seq)
    bases = [['A', 0], ['C', 0], ['G', 0], ['T', 0]]
    for c in seq, base in bases
        if c == base[1]
            base[2] += 1
        end
    end
    println("\nNucleotide counts for $seq:\n")
    for base in bases
        println(lpad(base[1], 10), lpad(string(base[2]), 12))
    end
    println(lpad("Other", 10), lpad(string(length(seq) - sum(x[2] for x in bases)), 12))
    println("     _________________\n", lpad("Total length", 14), lpad(string(length(seq)), 8))
end

"""Return the position in s1 of the start of overlap of tail of string s1 with head of string s2"""
function headtailoverlap(s1, s2, minimumoverlap=1)
    start = 1
    while true
        range = findnext(s2[1:minimumoverlap], s1, start)
        range == nothing && return 0
        start = range.start
        startswith(s2, s1[start:end]) && return length(s1) - start + 1
        start += 1
    end
end

"""Remove duplicates and strings contained within a larger string from vector of strings"""
function deduplicate(svect)
    filtered = empty(svect)
    arr = unique(svect)
    for (i, s1) in enumerate(arr)
        any(p -> p[1] != i && occursin(s1, p[2]), enumerate(arr)) && continue
        push!(filtered, s1)
    end
    return filtered
end

"""Returns shortest common superstring of a vector of strings"""
function shortest_common_superstring(svect)
    ss = deduplicate(svect)
    shortestsuper = prod(ss)
    for perm in permutations(ss)
        sup = first(perm)
        for i in 1:length(ss)-1
            overlap_position = headtailoverlap(perm[i], perm[i+1], 1)
            sup *= perm[i + 1][overlap_position+1:end]
        end
        if length(sup) < length(shortestsuper)
            shortestsuper = sup
        end
    end
    return shortestsuper
end

testsequences = [
["TA", "AAG", "TA", "GAA", "TA"],
["CATTAGGG", "ATTAG", "GGG", "TA"],
["AAGAUGGA", "GGAGCGCAUC", "AUCGCAAUAAGGA"],
["ATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTAT",
"GGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGT",
"CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA",
"TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
"AACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT",
"GCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTC",
"CGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATTCTGCTTATAACACTATGTTCT",
"TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
"CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATGCTCGTGC",
"GATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATT",
"TTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC",
"CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA",
"TCTCTTAAACTCCTGCTAAATGCTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGA"]
]

for test in testsequences
    scs = shortest_common_superstring(test)
    printcounts(scs)
end
