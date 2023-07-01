package main

import (
    "fmt"
    "math/rand"
    "sort"
    "time"
)

const bases = "ACGT"

// 'w' contains the weights out of 300 for each
// of swap, delete or insert in that order.
func mutate(dna string, w [3]int) string {
    le := len(dna)
    // get a random position in the dna to mutate
    p := rand.Intn(le)
    // get a random number between 0 and 299 inclusive
    r := rand.Intn(300)
    bytes := []byte(dna)
    switch {
    case r < w[0]: // swap
        base := bases[rand.Intn(4)]
        fmt.Printf("  Change @%3d %q to %q\n", p, bytes[p], base)
        bytes[p] = base
    case r < w[0]+w[1]: // delete
        fmt.Printf("  Delete @%3d %q\n", p, bytes[p])
        copy(bytes[p:], bytes[p+1:])
        bytes = bytes[0 : le-1]
    default: // insert
        base := bases[rand.Intn(4)]
        bytes = append(bytes, 0)
        copy(bytes[p+1:], bytes[p:])
        fmt.Printf("  Insert @%3d %q\n", p, base)
        bytes[p] = base
    }
    return string(bytes)
}

// Generate a random dna sequence of given length.
func generate(le int) string {
    bytes := make([]byte, le)
    for i := 0; i < le; i++ {
        bytes[i] = bases[rand.Intn(4)]
    }
    return string(bytes)
}

// Pretty print dna and stats.
func prettyPrint(dna string, rowLen int) {
    fmt.Println("SEQUENCE:")
    le := len(dna)
    for i := 0; i < le; i += rowLen {
        k := i + rowLen
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
    fmt.Println("    ======\n")
}

// Express weights as a string.
func wstring(w [3]int) string {
    return fmt.Sprintf("  Change: %d\n  Delete: %d\n  Insert: %d\n", w[0], w[1], w[2])
}

func main() {
    rand.Seed(time.Now().UnixNano())
    dna := generate(250)
    prettyPrint(dna, 50)
    muts := 10
    w := [3]int{100, 100, 100} // use e.g. {0, 300, 0} to choose only deletions
    fmt.Printf("WEIGHTS (ex 300):\n%s\n", wstring(w))
    fmt.Printf("MUTATIONS (%d):\n", muts)
    for i := 0; i < muts; i++ {
        dna = mutate(dna, w)
    }
    fmt.Println()
    prettyPrint(dna, 50)
}
