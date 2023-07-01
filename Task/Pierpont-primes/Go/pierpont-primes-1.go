package main

import (
    "fmt"
    big "github.com/ncw/gmp"
    "sort"
)

var (
    one   = new(big.Int).SetUint64(1)
    two   = new(big.Int).SetUint64(2)
    three = new(big.Int).SetUint64(3)
)

func pierpont(ulim, vlim int, first bool) []*big.Int {
    p := new(big.Int)
    p2 := new(big.Int).Set(one)
    p3 := new(big.Int).Set(one)
    var pp []*big.Int
    for v := 0; v < vlim; v++ {
        for u := 0; u < ulim; u++ {
            p.Mul(p2, p3)
            if first {
                p.Add(p, one)
            } else {
                p.Sub(p, one)
            }
            if p.ProbablyPrime(10) {
                q := new(big.Int)
                q.Set(p)
                pp = append(pp, q)
            }
            p2.Mul(p2, two)
        }
        p3.Mul(p3, three)
        p2.Set(one)
    }
    sort.Slice(pp, func(i, j int) bool {
        return pp[i].Cmp(pp[j]) < 0
    })
    return pp
}
func main() {
    fmt.Println("First 50 Pierpont primes of the first kind:")
    pp := pierpont(120, 80, true)
    for i := 0; i < 50; i++ {
        fmt.Printf("%8d ", pp[i])
        if (i-9)%10 == 0 {
            fmt.Println()
        }
    }
    fmt.Println("\nFirst 50 Pierpont primes of the second kind:")
    pp2 := pierpont(120, 80, false)
    for i := 0; i < 50; i++ {
        fmt.Printf("%8d ", pp2[i])
        if (i-9)%10 == 0 {
            fmt.Println()
        }
    }
    fmt.Println("\n250th Pierpont prime of the first kind:", pp[249])
    fmt.Println("\n250th Pierpont prime of the second kind:", pp2[249])
}
