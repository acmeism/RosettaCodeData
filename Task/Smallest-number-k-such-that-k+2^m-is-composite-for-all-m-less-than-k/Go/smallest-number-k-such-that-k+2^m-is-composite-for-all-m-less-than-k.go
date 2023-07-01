package main

import (
    "fmt"
    big "github.com/ncw/gmp"
)

// returns true if k is a sequence member, false otherwise
func a(k int64) bool {
    if k == 1 {
        return false
    }
    bk := big.NewInt(k)
    for m := uint(1); m < uint(k); m++ {
        n := big.NewInt(1)
        n.Lsh(n, m)
        n.Add(n, bk)
        if n.ProbablyPrime(15) {
            return false
        }
    }
    return true
}

func main() {
    count := 0
    k := int64(1)
    for count < 5 {
        if a(k) {
            fmt.Printf("%d ", k)
            count++
        }
        k += 2
    }
    fmt.Println()
}
