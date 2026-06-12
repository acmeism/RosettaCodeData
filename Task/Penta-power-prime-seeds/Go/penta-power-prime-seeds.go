package main

import (
    "fmt"
    big "github.com/ncw/gmp"
    "rcu"
)

var p, p2, q *big.Int

func isPentaPowerPrimeSeed(n uint64) bool {
    nn := new(big.Int).SetUint64(n)
    p.Set(nn)
    k := new(big.Int).SetUint64(n + 1)
    p2.Add(q, k)
    if !p2.ProbablyPrime(15) {
        return false
    }
    p2.Add(p, k)
    if !p2.ProbablyPrime(15) {
        return false
    }
    for i := 0; i < 3; i++ {
        p.Mul(p, nn)
        p2.Set(p)
        p2.Add(p2, k)
        if !p2.ProbablyPrime(15) {
            return false
        }
    }
    return true
}

func ord(c int) string {
    m := c % 100
    if m > 4 && m <= 20 {
        return "th"
    }
    m %= 10
    switch m {
    case 1:
        return "st"
    case 2:
        return "nd"
    case 3:
        return "rd"
    default:
        return "th"
    }
}

func main() {
    p = new(big.Int)
    p2 = new(big.Int)
    q = big.NewInt(1)
    c := 0
    m := 1
    n := uint64(1)
    fmt.Println("First thirty penta-power prime seeds:")
    for ; c < 30; n += 2 {
        if isPentaPowerPrimeSeed(n) {
            fmt.Printf("%9s ", rcu.Commatize(int(n)))
            c++
            if c%10 == 0 {
                fmt.Println()
            }
        }
    }

    n = 1
    c = 0
    fmt.Println("\nFirst penta-power prime seed greater than:")
    for {
        if isPentaPowerPrimeSeed(n) {
            c++
            if n > 1000000*uint64(m) {
                ns := rcu.Commatize(int(n))
                fmt.Printf(" %2d million is the %d%s: %10s\n", m, c, ord(c), ns)
                m++
                if m == 11 {
                    break
                }
            }
        }
        n += 2
    }
}
