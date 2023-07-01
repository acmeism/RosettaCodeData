import "/fmt" for Fmt
import "/seq" for Lst
import "/str" for Str
import "/math" for Int

/* Gets all permutations of a list of strings. */
var getPerms = Fn.new { |input|
    var perms = [input]
    var a = input.toList
    var n = a.count - 1
    for (c in 1...Int.factorial(n+1)) {
        var i = n - 1
        var j = n
        while (Str.gt(a[i], a[i+1])) i = i - 1
        while (Str.lt(a[j], a[i]))   j = j - 1
        var t = a[i]
        a[i] = a[j]
        a[j] = t
        j = n
        i = i + 1
        while (i < j) {
            t = a[i]
            a[i] = a[j]
            a[j] = t
            i = i + 1
            j = j - 1
        }
        perms.add(a.toList)
    }
    return perms
}

/* Given a DNA sequence, report the sequence, length and base counts. */
var printCounts = Fn.new { |seq|
    var bases = [["A", 0], ["C", 0], ["G", 0], ["T", 0]]
    for (c in seq) {
        for (base in bases) {
            if (c == base[0]) base[1] = base[1] + 1
        }
    }
    System.print("\nNucleotide counts for %(seq):\n")
    for (base in bases) Fmt.print("$10s$12d", base[0], base[1])
    var sum = bases.reduce(0) { |acc, x| acc + x[1] }
    Fmt.print("$10s$12d", "Other", seq.count - sum)
    Fmt.print("  ____________________\n$14s$8d", "Total length", seq.count)
}

/* Return the position in s1 of the start of overlap of tail of string s1 with head of string s2. */
var headTailOverlap = Fn.new { |s1, s2|
    var start = 0
    while (true) {
        start = s1.indexOf(s2[0], start)
        if (start == -1) return 0
        if (s2.startsWith(s1[start..-1])) return s1.count - start
        start = start + 1
    }
}

/* Remove duplicates and strings contained within a larger string from a list of strings. */
var deduplicate = Fn.new { |slist|
    var filtered = []
    var arr = Lst.distinct(slist)
    var i = 0
    for (s1 in arr) {
        var j = 0
        var withinLarger = false
        for (s2 in arr) {
            if (j != i && s2.contains(s1)) {
                withinLarger = true
                break
            }
            j = j + 1
        }
        if (!withinLarger) filtered.add(s1)
        i = i + 1
    }
    return filtered
}

/* Returns shortest common superstring of a list of strings. */
var shortestCommonSuperstring = Fn.new { |slist|
    var ss = deduplicate.call(slist)
    var shortestSuper = ss.join()
    for (perm in getPerms.call(ss)) {
        var sup = perm[0]
        for (i in 0...ss.count-1) {
            var overlapPos = headTailOverlap.call(perm[i], perm[i+1])
            sup = sup + perm[i+1][overlapPos..-1]
        }
        if (sup.count < shortestSuper.count) shortestSuper = sup
    }
    return shortestSuper
}

var testSequences = [
    ["TA", "AAG", "TA", "GAA", "TA"],
    ["CATTAGGG", "ATTAG", "GGG", "TA"],
    ["AAGAUGGA", "GGAGCGCAUC", "AUCGCAAUAAGGA"],
    [
        "ATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTAT",
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
        "TCTCTTAAACTCCTGCTAAATGCTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGA"
    ]
]

for (test in testSequences) {
    var scs = shortestCommonSuperstring.call(test)
    printCounts.call(scs)
}
