package main

import (
    "fmt"
    "rcu"
)

func main() {
    primes := rcu.Primes(101)
    var frobenius []int
    for i := 0; i < len(primes)-1; i++ {
        frob := primes[i]*primes[i+1] - primes[i] - primes[i+1]
        if frob >= 10000 {
            break
        }
        frobenius = append(frobenius, frob)
    }
    fmt.Println("Frobenius numbers under 10,000:")
    for i, n := range frobenius {
        fmt.Printf("%5s ", rcu.Commatize(n))
        if (i+1)%9 == 0 {
            fmt.Println()
        }
    }
    fmt.Printf("\n\n%d such numbers found.\n", len(frobenius))
}
