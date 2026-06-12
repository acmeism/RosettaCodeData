package main

import (
    "fmt"
    "sort"
)

func main() {
    dna := "" +
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

    fmt.Println("SEQUENCE:")
    le := len(dna)
    for i := 0; i < le; i += 50 {
        k := i + 50
        if k > le {
            k = le
        }
        fmt.Printf("%5d: %s\n", i, dna[i:k])
    }
    baseMap := make(map[byte]int) // allows for 'any' base
    for i := 0; i < le; i++ {
        baseMap[dna[i]]++
    }
    var bases []byte
    for k := range baseMap {
        bases = append(bases, k)
    }
    sort.Slice(bases, func(i, j int) bool { // get bases into alphabetic order
        return bases[i] < bases[j]
    })

    fmt.Println("\nBASE COUNT:")
    for _, base := range bases {
        fmt.Printf("    %c: %3d\n", base, baseMap[base])
    }
    fmt.Println("    ------")
    fmt.Println("    Σ:", le)
    fmt.Println("    ======")
}
