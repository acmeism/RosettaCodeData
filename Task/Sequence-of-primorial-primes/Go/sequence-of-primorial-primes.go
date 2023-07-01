package main

import (
    "fmt"
    "math/big"
)

func main() {
    one := big.NewInt(1)
    pm := big.NewInt(1) // primorial
    var px, nx int
    var pb big.Int // a scratch value
    primes(4000, func(p int64) bool {
        pm.Mul(pm, pb.SetInt64(p))
        px++
        if pb.Add(pm, one).ProbablyPrime(0) ||
            pb.Sub(pm, one).ProbablyPrime(0) {
            fmt.Print(px, " ")
            nx++
            if nx == 20 {
                fmt.Println()
                return false
            }
        }
        return true
    })
}

// Code taken from task Sieve of Eratosthenes, and put into this function
// that calls callback function f for each prime < limit, but terminating
// if the callback returns false.
func primes(limit int, f func(int64) bool) {
    c := make([]bool, limit)
    c[0] = true
    c[1] = true
    lm := int64(limit)
    p := int64(2)
    for {
        f(p)
        p2 := p * p
        if p2 >= lm {
            break
        }
        for i := p2; i < lm; i += p {
            c[i] = true
        }
        for {
            p++
            if !c[p] {
                break
            }
        }
    }
    for p++; p < lm; p++ {
        if !c[p] && !f(p) {
            break
        }
    }
}
