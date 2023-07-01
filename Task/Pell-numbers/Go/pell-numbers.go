package main

import (
    "fmt"
    "math/big"
    "rcu"
)

func main() {
    p := make([]int64, 40)
    p[1] = 1
    for i := 2; i < 40; i++ {
        p[i] = 2*p[i-1] + p[i-2]
    }
    fmt.Println("The first 20 Pell numbers are:")
    fmt.Println(p[0:20])

    q := make([]int64, 40)
    q[0] = 2
    q[1] = 2
    for i := 2; i < 40; i++ {
        q[i] = 2*q[i-1] + q[i-2]
    }
    fmt.Println("\nThe first 20 Pell-Lucas numbers are:")
    fmt.Println(q[0:20])

    fmt.Println("\nThe first 20 rational approximations of √2 (1.4142135623730951) are:")
    for i := 1; i <= 20; i++ {
        r := big.NewRat(q[i]/2, p[i])
        fmt.Printf("%-17s ≈ %-18s\n", r, r.FloatString(16))
    }

    fmt.Println("\nThe first 15 Pell primes are:")
    p0 := big.NewInt(0)
    p1 := big.NewInt(1)
    p2 := big.NewInt(0)
    two := big.NewInt(2)
    indices := make([]int, 15)
    for index, count := 2, 0; count < 15; index++ {
        p2.Mul(p1, two)
        p2.Add(p2, p0)
        if rcu.IsPrime(index) && p2.ProbablyPrime(15) {
            fmt.Println(p2)
            indices[count] = index
            count++
        }
        p0.Set(p1)
        p1.Set(p2)
    }

    fmt.Println("\nIndices of the first 15 Pell primes are:")
    fmt.Println(indices)

    fmt.Println("\nFirst 20 Newman-Shank_Williams numbers:")
    nsw := make([]int64, 20)
    for n := 0; n < 20; n++ {
        nsw[n] = p[2*n] + p[2*n+1]
    }
    fmt.Println(nsw)

    fmt.Println("\nFirst 20 near isosceles right triangles:")
    u0 := 0
    u1 := 1
    sum := 1
    for i := 2; i < 43; i++ {
        u2 := u1*2 + u0
        if i%2 == 1 {
            fmt.Printf("(%d, %d, %d)\n", sum, sum+1, u2)
        }
        sum += u2
        u0 = u1
        u1 = u2
    }
}
