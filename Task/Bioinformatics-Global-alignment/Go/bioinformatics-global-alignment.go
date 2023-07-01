package main

import (
    "fmt"
    "strings"
)

/* Gets n! for small n. */
func factorial(n int) int {
    fact := 1
    for i := 2; i <= n; i++ {
        fact *= i
    }
    return fact
}

/* Gets all permutations of a list of strings. */
func getPerms(input []string) [][]string {
    perms := [][]string{input}
    le := len(input)
    a := make([]string, le)
    copy(a, input)
    n := le - 1
    fact := factorial(n + 1)

    for c := 1; c < fact; c++ {
        i := n - 1
        j := n
        for i >= 0 && a[i] > a[i+1] {
            i--
        }
        if i == -1 {
            i = n
        }
        for a[j] < a[i] {
            j--
        }
        a[i], a[j] = a[j], a[i]
        j = n
        i++
        if i == n+1 {
            i = 0
        }
        for i < j {
            a[i], a[j] = a[j], a[i]
            i++
            j--
        }
        b := make([]string, le)
        copy(b, a)
        perms = append(perms, b)
    }
    return perms
}

/* Returns all distinct elements from a list of strings. */
func distinct(slist []string) []string {
    distinctSet := make(map[string]int, len(slist))
    i := 0
    for _, s := range slist {
        if _, ok := distinctSet[s]; !ok {
            distinctSet[s] = i
            i++
        }
    }
    result := make([]string, len(distinctSet))
    for s, i := range distinctSet {
        result[i] = s
    }
    return result
}

/* Given a DNA sequence, report the sequence, length and base counts. */
func printCounts(seq string) {
    bases := [][]rune{{'A', 0}, {'C', 0}, {'G', 0}, {'T', 0}}
    for _, c := range seq {
        for _, base := range bases {
            if c == base[0] {
                base[1]++
            }
        }
    }
    sum := 0
    fmt.Println("\nNucleotide counts for", seq, "\b:\n")
    for _, base := range bases {
        fmt.Printf("%10c%12d\n", base[0], base[1])
        sum += int(base[1])
    }
    le := len(seq)
    fmt.Printf("%10s%12d\n", "Other", le-sum)
    fmt.Printf("  ____________________\n%14s%8d\n", "Total length", le)
}

/* Return the position in s1 of the start of overlap of tail of string s1 with head of string s2. */
func headTailOverlap(s1, s2 string) int {
    for start := 0; ; start++ {
        ix := strings.IndexByte(s1[start:], s2[0])
        if ix == -1 {
            return 0
        } else {
            start += ix
        }
        if strings.HasPrefix(s2, s1[start:]) {
            return len(s1) - start
        }
    }
}

/* Remove duplicates and strings contained within a larger string from a list of strings. */
func deduplicate(slist []string) []string {
    var filtered []string
    arr := distinct(slist)
    for i, s1 := range arr {
        withinLarger := false
        for j, s2 := range arr {
            if j != i && strings.Contains(s2, s1) {
                withinLarger = true
                break
            }
        }
        if !withinLarger {
            filtered = append(filtered, s1)
        }
    }
    return filtered
}

/* Returns shortest common superstring of a list of strings. */
func shortestCommonSuperstring(slist []string) string {
    ss := deduplicate(slist)
    shortestSuper := strings.Join(ss, "")
    for _, perm := range getPerms(ss) {
        sup := perm[0]
        for i := 0; i < len(ss)-1; i++ {
            overlapPos := headTailOverlap(perm[i], perm[i+1])
            sup += perm[i+1][overlapPos:]
        }
        if len(sup) < len(shortestSuper) {
            shortestSuper = sup
        }
    }
    return shortestSuper
}

func main() {
    testSequences := [][]string{
        {"TA", "AAG", "TA", "GAA", "TA"},
        {"CATTAGGG", "ATTAG", "GGG", "TA"},
        {"AAGAUGGA", "GGAGCGCAUC", "AUCGCAAUAAGGA"},
        {
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
            "TCTCTTAAACTCCTGCTAAATGCTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGA",
        },
    }

    for _, test := range testSequences {
        scs := shortestCommonSuperstring(test)
        printCounts(scs)
    }
}
