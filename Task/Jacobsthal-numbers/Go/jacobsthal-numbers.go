package main

import (
    "fmt"
    "math/big"
)

func jacobsthal(n uint) *big.Int {
    t := big.NewInt(1)
    t.Lsh(t, n)
    s := big.NewInt(1)
    if n%2 != 0 {
        s.Neg(s)
    }
    t.Sub(t, s)
    return t.Div(t, big.NewInt(3))
}

func jacobsthalLucas(n uint) *big.Int {
    t := big.NewInt(1)
    t.Lsh(t, n)
    a := big.NewInt(1)
    if n%2 != 0 {
        a.Neg(a)
    }
    return t.Add(t, a)
}

func main() {
    jac := make([]*big.Int, 30)
    fmt.Println("First 30 Jacobsthal numbers:")
    for i := uint(0); i < 30; i++ {
        jac[i] = jacobsthal(i)
        fmt.Printf("%9d ", jac[i])
        if (i+1)%5 == 0 {
            fmt.Println()
        }
    }

    fmt.Println("\nFirst 30 Jacobsthal-Lucas numbers:")
    for i := uint(0); i < 30; i++ {
        fmt.Printf("%9d ", jacobsthalLucas(i))
        if (i+1)%5 == 0 {
            fmt.Println()
        }
    }

    fmt.Println("\nFirst 20 Jacobsthal oblong numbers:")
    for i := uint(0); i < 20; i++ {
        t := big.NewInt(0)
        fmt.Printf("%11d ", t.Mul(jac[i], jac[i+1]))
        if (i+1)%5 == 0 {
            fmt.Println()
        }
    }

    fmt.Println("\nFirst 20 Jacobsthal primes:")
    for n, count := uint(0), 0; count < 20; n++ {
        j := jacobsthal(n)
        if j.ProbablyPrime(10) {
            fmt.Println(j)
            count++
        }
    }
}
