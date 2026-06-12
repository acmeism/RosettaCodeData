package main

import (
    "fmt"
    "math"
    "rcu"
)

func main() {
    limit := 999999
    primes := rcu.Primes(limit)
    fmt.Println("Adjacent primes under 1,000,000 whose difference is a square > 36:")
    for i := 1; i < len(primes); i++ {
        diff := primes[i] - primes[i-1]
        if diff > 36 {
            s := int(math.Sqrt(float64(diff)))
            if diff == s*s {
                cp1 := rcu.Commatize(primes[i])
                cp2 := rcu.Commatize(primes[i-1])
                fmt.Printf("%7s - %7s = %3d = %2d x %2d\n", cp1, cp2, diff, s, s)
            }
        }
    }
}
