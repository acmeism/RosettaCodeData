package main

import (
    "fmt"
    "rcu"
    "sort"
)

func main() {
    primes := rcu.Primes(333)
    var oss []int
    for i := 1; i < len(primes)-1; i++ {
        for j := i + 1; j < len(primes); j++ {
            n := primes[i] * primes[j]
            if n >= 1000 {
                break
            }
            oss = append(oss, n)
        }
    }
    sort.Ints(oss)
    fmt.Println("Odd squarefree semiprimes under 1,000:")
    for i, n := range oss {
        fmt.Printf("%3d ", n)
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }
    fmt.Printf("\n\n%d such numbers found.\n", len(oss))
}
