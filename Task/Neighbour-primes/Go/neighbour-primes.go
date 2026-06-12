package main

import (
    "fmt"
    "rcu"
)

func main() {
    primes := rcu.Primes(504)
    var nprimes []int
    fmt.Println("Neighbour primes < 500:")
    for i := 0; i < len(primes)-1; i++ {
        p := primes[i]*primes[i+1] + 2
        if rcu.IsPrime(p) {
            nprimes = append(nprimes, primes[i])
        }
    }
    rcu.PrintTable(nprimes, 10, 3, false)
    fmt.Println("\nFound", len(nprimes), "such primes.")
}
