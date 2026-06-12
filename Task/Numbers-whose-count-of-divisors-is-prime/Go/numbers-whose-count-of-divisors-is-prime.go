package main

import (
    "fmt"
    "rcu"
)

func countDivisors(n int) int {
    count := 0
    i := 1
    k := 1
    if n%2 == 1 {
        k = 2
    }
    for ; i*i <= n; i += k {
        if n%i == 0 {
            count++
            j := n / i
            if j != i {
                count++
            }
        }
    }
    return count
}

func main() {
    const limit = 1e5
    var results []int
    for i := 2; i * i < limit; i++ {
        n := countDivisors(i * i)
        if n > 2 && rcu.IsPrime(n) {
            results = append(results, i * i)
        }
    }
    climit := rcu.Commatize(limit)
    fmt.Printf("Positive integers under %7s whose number of divisors is an odd prime:\n", climit)
    under1000 := 0
    for i, n := range results {
        fmt.Printf("%7s", rcu.Commatize(n))
        if (i+1)%10 == 0 {
            fmt.Println()
        }
        if n < 1000 {
            under1000++
        }
    }
    fmt.Printf("\n\nFound %d such integers (%d under 1,000).\n", len(results), under1000)
}
