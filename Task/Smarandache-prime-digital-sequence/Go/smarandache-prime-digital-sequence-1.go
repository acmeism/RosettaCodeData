package main

import (
    "fmt"
    "math/big"
)

var b = new(big.Int)

func isSPDSPrime(n uint64) bool {
    nn := n
    for nn > 0 {
        r := nn % 10
        if r != 2 && r != 3 && r != 5 && r != 7 {
            return false
        }
        nn /= 10
    }
    b.SetUint64(n)
    if b.ProbablyPrime(0) { // 100% accurate up to 2 ^ 64
        return true
    }
    return false
}

func listSPDSPrimes(startFrom, countFrom, countTo uint64, printOne bool) uint64 {
    count := countFrom
    for n := startFrom; ; n += 2 {
        if isSPDSPrime(n) {
            count++
            if !printOne {
                fmt.Printf("%2d. %d\n", count, n)
            }
            if count == countTo {
                if printOne {
                    fmt.Println(n)
                }
                return n
            }
        }
    }
}

func main() {
    fmt.Println("The first 25 terms of the Smarandache prime-digital sequence are:")
    fmt.Println(" 1. 2")
    n := listSPDSPrimes(3, 1, 25, false)
    fmt.Println("\nHigher terms:")
    indices := []uint64{25, 100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000}
    for i := 1; i < len(indices); i++ {
        fmt.Printf("%6d. ", indices[i])
        n = listSPDSPrimes(n+2, indices[i-1], indices[i], true)
    }
}
