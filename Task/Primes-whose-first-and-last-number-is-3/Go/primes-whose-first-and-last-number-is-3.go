package main

import (
    "fmt"
    "rcu"
)

func main() {
    var primes []int
    candidates := []int{3, 33}
    for i := 303; i <= 393; i += 10 {
        candidates = append(candidates, i)
    }
    for i := 3003; i <= 3993; i += 10 {
        candidates = append(candidates, i)
    }
    for _, cand := range candidates {
        if rcu.IsPrime(cand) {
            primes = append(primes, cand)
        }
    }
    fmt.Println("Primes under 4,000 which begin and end in 3:")
    for i, p := range primes {
        fmt.Printf("%5s ", rcu.Commatize(p))
        if (i+1)%11 == 0 {
            fmt.Println()
        }
    }
    fmt.Println("\nFound", len(primes), "Such primes.")
    pc := len(primes)
    for i := 30003; i <= 39993; i += 10 {
        if rcu.IsPrime(i) {
            pc++
        }
    }
    for i := 300003; i <= 399993; i += 10 {
        if rcu.IsPrime(i) {
            pc++
        }
    }
    pcc := rcu.Commatize(pc)
    fmt.Println("\nFound", pcc, "primes under 1,000,000 which begin and end with 3.")
}
