package main

import (
    "fmt"
    big "github.com/ncw/gmp"
    "rcu"
    "strings"
)

func main() {
    limit := 2700
    primes := rcu.Primes(limit)
    s := new(big.Int)
    for b := 2; b <= 36; b++ {
        var rPrimes []int
        for _, p := range primes {
            s.SetString(strings.Repeat("1", p), b)
            if s.ProbablyPrime(15) {
                rPrimes = append(rPrimes, p)
            }
        }
        fmt.Printf("Base %2d: %v\n", b, rPrimes)
    }
}
