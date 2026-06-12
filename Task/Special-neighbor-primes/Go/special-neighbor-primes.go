package main

import (
    "fmt"
    "rcu"
)

const MAX = 9_999_999

var primes = rcu.Primes(MAX)

func specialNP(limit int, showAll bool) {
    if showAll {
        fmt.Println("Neighbor primes, p1 and p2, where p1 + p2 - 1 is prime:")
    }
    count := 0
    for i := 1; i < len(primes); i++ {
        p2 := primes[i]
        if p2 >= limit {
            break
        }
        p1 := primes[i-1]
        p3 := p1 + p2 - 1
        if rcu.IsPrime(p3) {
            if showAll {
                fmt.Printf("(%2d, %2d) => %3d\n", p1, p2, p3)
            }
            count++
        }
    }
    ccount := rcu.Commatize(count)
    climit := rcu.Commatize(limit)
    fmt.Printf("\nFound %s special neighbor primes under %s.\n", ccount, climit)
}

func main() {
    specialNP(100, true)
    var pow = 1000
    for i := 3; i < 8; i++ {
        specialNP(pow, false)
        pow *= 10
    }
}
