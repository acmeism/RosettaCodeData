package main

import (
    "fmt"
    "rcu"
)

func main() {
    limit := int(1e10 - 1)
    primes := rcu.Primes(limit)
    maxI := 0
    maxDiff := 0
    nextStop := 10
    fmt.Println("The largest differences between adjacent primes under the following limits is:")
    for i := 1; i < len(primes); i++ {
        diff := primes[i] - primes[i-1]
        if diff > maxDiff {
            maxDiff = diff
            maxI = i
        }
        if i == len(primes)-1 || primes[i+1] > nextStop {
            c1 := rcu.Commatize(nextStop)
            c2 := rcu.Commatize(primes[maxI])
            c3 := rcu.Commatize(primes[maxI-1])
            c4 := rcu.Commatize(maxDiff)
            fmt.Printf("Under %s: %s - %s = %s\n", c1, c2, c3, c4)
            nextStop *= 10
        }
    }
}
