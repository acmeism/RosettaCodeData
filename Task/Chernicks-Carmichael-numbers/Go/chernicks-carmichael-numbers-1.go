package main

import (
    "fmt"
    "math/big"
)

var (
    zero = new(big.Int)
    prod = new(big.Int)
    fact = new(big.Int)
)

func ccFactors(n, m uint64) (*big.Int, bool) {
    prod.SetUint64(6*m + 1)
    if !prod.ProbablyPrime(0) {
        return zero, false
    }
    fact.SetUint64(12*m + 1)
    if !fact.ProbablyPrime(0) { // 100% accurate up to 2 ^ 64
        return zero, false
    }
    prod.Mul(prod, fact)
    for i := uint64(1); i <= n-2; i++ {
        fact.SetUint64((1<<i)*9*m + 1)
        if !fact.ProbablyPrime(0) {
            return zero, false
        }
        prod.Mul(prod, fact)
    }
    return prod, true
}

func ccNumbers(start, end uint64) {
    for n := start; n <= end; n++ {
        m := uint64(1)
        if n > 4 {
            m = 1 << (n - 4)
        }
        for {
            num, ok := ccFactors(n, m)
            if ok {
                fmt.Printf("a(%d) = %d\n", n, num)
                break
            }
            if n <= 4 {
                m++
            } else {
                m += 1 << (n - 4)
            }
        }
    }
}

func main() {
    ccNumbers(3, 9)
}
