package main

import (
    "fmt"
    "math/rand"
    "regexp"
    "time"
)

const base = "ACGT"

func findDnaSubsequence(dnaSize, chunkSize int) {
    dnaSeq := make([]byte, dnaSize)
    for i := 0; i < dnaSize; i++ {
        dnaSeq[i] = base[rand.Intn(4)]
    }
    dnaStr := string(dnaSeq)
    dnaSubseq := make([]byte, 4)
    for i := 0; i < 4; i++ {
        dnaSubseq[i] = base[rand.Intn(4)]
    }
    dnaSubstr := string(dnaSubseq)
    fmt.Println("DNA sequnence:")
    for i := chunkSize; i <= len(dnaStr); i += chunkSize {
        start := i - chunkSize
        fmt.Printf("%3d..%3d: %s\n", start+1, i, dnaStr[start:i])
    }
    fmt.Println("\nSubsequence to locate:", dnaSubstr)
    var r = regexp.MustCompile(dnaSubstr)
    var matches = r.FindAllStringIndex(dnaStr, -1)
    if len(matches) == 0 {
        fmt.Println("No matches found.")
    } else {
        fmt.Println("Matches found at the following indices:")
        for _, m := range matches {
            fmt.Printf("%3d..%-3d\n", m[0]+1, m[1])
        }
    }
}

func main() {
    rand.Seed(time.Now().UnixNano())
    findDnaSubsequence(200, 20)
    fmt.Println()
    findDnaSubsequence(600, 40)
}
