package main

import (
    "fmt"
    "rcu"
)

func main() {
    primes := rcu.Primes(999)
    sum, n, c := 0, 0, 0
    fmt.Println("Summing the first n primes (<1,000) where the sum is itself prime:")
    fmt.Println("  n  cumulative sum")
    for _, p := range primes {
        n++
        sum += p
        if rcu.IsPrime(sum) {
            c++
            fmt.Printf("%3d   %6s\n", n, rcu.Commatize(sum))
        }
    }
    fmt.Println()
    fmt.Println(c, "such prime sums found")
}
