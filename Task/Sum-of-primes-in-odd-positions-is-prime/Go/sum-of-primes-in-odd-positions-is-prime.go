package main

import (
    "fmt"
    "rcu"
)

func main() {
    primes := rcu.Primes(999)
    sum := 0
    fmt.Println(" i   p[i]  Σp[i]")
    fmt.Println("----------------")
    for i := 0; i < len(primes); i += 2 {
        sum += primes[i]
        if rcu.IsPrime(sum) {
            fmt.Printf("%3d  %3d  %6s\n", i+1, primes[i], rcu.Commatize(sum))
        }
    }
}
