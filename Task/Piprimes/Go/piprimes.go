package main

import (
    "fmt"
    "rcu"
)

func main() {
    primes := rcu.Primes(79) // go up to the 22nd
    ix := 0
    n := 1
    count := 0
    var pi []int
    for {
        if primes[ix] <= n {
            count++
            if count == 22 {
                break
            }
            ix++
        }
        n++
        pi = append(pi, count)
    }
    fmt.Println("pi(n), the number of primes <= n, where n >= 1 and pi(n) < 22:")
    for i, n := range pi {
        fmt.Printf("%2d ", n)
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }
    fmt.Printf("\n\nHighest n for this range = %d.\n", len(pi))
}
