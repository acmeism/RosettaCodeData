package main

import (
    "fmt"
    "math"
    "rcu"
)

func contains(a []int, f int) bool {
    for _, e := range a {
        if e == f {
            return true
        }
    }
    return false
}

func main() {
    const euler = 0.57721566490153286
    primes := rcu.Primes(1 << 31)
    pc := len(primes)
    sum := 0.0
    fmt.Println("Primes added         M")
    fmt.Println("------------  --------------")
    for i, p := range primes {
        rp := 1.0 / float64(p)
        sum += math.Log(1.0-rp) + rp
        c := i + 1
        if (c%1e7) == 0 || c == pc {
            fmt.Printf("%11s   %0.12f\n", rcu.Commatize(c), sum+euler)
        }
    }
}
