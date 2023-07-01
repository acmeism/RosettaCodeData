package main

import (
    "fmt"
    "math/big"
    "rcu"
)

func main() {
    const LIMIT = 11000
    primes := rcu.Primes(LIMIT)
    facts := make([]*big.Int, LIMIT)
    facts[0] = big.NewInt(1)
    for i := int64(1); i < LIMIT; i++ {
        facts[i] = new(big.Int)
        facts[i].Mul(facts[i-1], big.NewInt(i))
    }
    sign := int64(1)
    f := new(big.Int)
    zero := new(big.Int)
    fmt.Println(" n:  Wilson primes")
    fmt.Println("--------------------")
    for n := 1; n < 12; n++ {
        fmt.Printf("%2d:  ", n)
        sign = -sign
        for _, p := range primes {
            if p < n {
                continue
            }
            f.Mul(facts[n-1], facts[p-n])
            f.Sub(f, big.NewInt(sign))
            p2 := int64(p * p)
            bp2 := big.NewInt(p2)
            if f.Rem(f, bp2).Cmp(zero) == 0 {
                fmt.Printf("%d ", p)
            }
        }
        fmt.Println()
    }
}
