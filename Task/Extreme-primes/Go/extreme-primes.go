package main

import (
    "fmt"
    big "github.com/ncw/gmp"
    "rcu"
)

func nextPrime(n *big.Int) *big.Int {
    m := new(big.Int).Set(n)
    z := new(big.Int)
    zero := new(big.Int)
    one := big.NewInt(1)
    two := big.NewInt(2)
    if z.Rem(m, two).Cmp(zero) == 0 {
        m.Add(m, one)
    } else {
        m.Add(m, two)
    }
    for {
        if m.ProbablyPrime(0) {
            return m
        }
        m.Add(m, two)
    }
}

func main() {
    extremes := []int{2}
    sum := big.NewInt(2)
    count := 1
    p := big.NewInt(3)
    for {
        sum.Add(sum, p)
        if sum.ProbablyPrime(0) {
            count++
            if count <= 30 {
                extremes = append(extremes, int(sum.Uint64()))
            }
            if count == 30 {
                fmt.Println("The first 30 extreme primes are:")
                rcu.PrintTable(extremes, 6, 7, true)
                fmt.Println()
            } else if count%1000 == 0 {
                m := count / 1000
                if m < 6 || m == 30 || m == 40 || m == 50 {
                    scount := rcu.Commatize(count)
                    ssum := rcu.Commatize(sum.Uint64())
                    sp := rcu.Commatize(p.Uint64())
                    fmt.Printf("The %6sth extreme prime is: %18s for p <= %10s\n", scount, ssum, sp)
                    if m == 50 {
                        return
                    }
                }
            }
        }
        p.Set(nextPrime(p))
    }
}
