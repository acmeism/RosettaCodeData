package main

import (
    "fmt"
    "math/big"
    "rcu"
    "sort"
)

func main() {
    primes := rcu.Primes(379)
    primorial := big.NewInt(1)
    var fortunates []int
    bPrime := new(big.Int)
    for _, prime := range primes {
        bPrime.SetUint64(uint64(prime))
        primorial.Mul(primorial, bPrime)
        for j := 3; ; j += 2 {
            jj := big.NewInt(int64(j))
            bPrime.Add(primorial, jj)
            if bPrime.ProbablyPrime(5) {
                fortunates = append(fortunates, j)
                break
            }
        }
    }
    m := make(map[int]bool)
    for _, f := range fortunates {
        m[f] = true
    }
    fortunates = fortunates[:0]
    for k := range m {
        fortunates = append(fortunates, k)
    }
    sort.Ints(fortunates)
    fmt.Println("After sorting, the first 50 distinct fortunate numbers are:")
    for i, f := range fortunates[0:50] {
        fmt.Printf("%3d ", f)
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }
    fmt.Println()
}
