package main

import (
    "fmt"
    big "github.com/ncw/gmp"
)

func cullen(n uint) *big.Int {
    one := big.NewInt(1)
    bn := big.NewInt(int64(n))
    res := new(big.Int).Lsh(one, n)
    res.Mul(res, bn)
    return res.Add(res, one)
}

func woodall(n uint) *big.Int {
    res := cullen(n)
    return res.Sub(res, big.NewInt(2))
}

func main() {
    fmt.Println("First 20 Cullen numbers (n * 2^n + 1):")
    for n := uint(1); n <= 20; n++ {
        fmt.Printf("%d ", cullen(n))
    }

    fmt.Println("\n\nFirst 20 Woodall numbers (n * 2^n - 1):")
    for n := uint(1); n <= 20; n++ {
        fmt.Printf("%d ", woodall(n))
    }

    fmt.Println("\n\nFirst 5 Cullen primes (in terms of n):")
    count := 0
    for n := uint(1); count < 5; n++ {
        cn := cullen(n)
        if cn.ProbablyPrime(15) {
            fmt.Printf("%d ", n)
            count++
        }
    }

    fmt.Println("\n\nFirst 12 Woodall primes (in terms of n):")
    count = 0
    for n := uint(1); count < 12; n++ {
        cn := woodall(n)
        if cn.ProbablyPrime(15) {
            fmt.Printf("%d ", n)
            count++
        }
    }
    fmt.Println()
}
