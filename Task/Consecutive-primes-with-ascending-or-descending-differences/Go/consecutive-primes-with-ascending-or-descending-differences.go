package main

import (
    "fmt"
    "rcu"
)

const LIMIT = 999999

var primes = rcu.Primes(LIMIT)

func longestSeq(dir string) {
    pd := 0
    longSeqs := [][]int{{2}}
    currSeq := []int{2}
    for i := 1; i < len(primes); i++ {
        d := primes[i] - primes[i-1]
        if (dir == "ascending" && d <= pd) || (dir == "descending" && d >= pd) {
            if len(currSeq) > len(longSeqs[0]) {
                longSeqs = [][]int{currSeq}
            } else if len(currSeq) == len(longSeqs[0]) {
                longSeqs = append(longSeqs, currSeq)
            }
            currSeq = []int{primes[i-1], primes[i]}
        } else {
            currSeq = append(currSeq, primes[i])
        }
        pd = d
    }
    if len(currSeq) > len(longSeqs[0]) {
        longSeqs = [][]int{currSeq}
    } else if len(currSeq) == len(longSeqs[0]) {
        longSeqs = append(longSeqs, currSeq)
    }
    fmt.Println("Longest run(s) of primes with", dir, "differences is", len(longSeqs[0]), ":")
    for _, ls := range longSeqs {
        var diffs []int
        for i := 1; i < len(ls); i++ {
            diffs = append(diffs, ls[i]-ls[i-1])
        }
        for i := 0; i < len(ls)-1; i++ {
            fmt.Print(ls[i], " (", diffs[i], ") ")
        }
        fmt.Println(ls[len(ls)-1])
    }
    fmt.Println()
}

func main() {
    fmt.Println("For primes < 1 million:\n")
    for _, dir := range []string{"ascending", "descending"} {
        longestSeq(dir)
    }
}
