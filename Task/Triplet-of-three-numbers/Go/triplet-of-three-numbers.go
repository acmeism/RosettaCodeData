package main

import (
    "fmt"
    "rcu"
)

func main() {
    c := rcu.PrimeSieve(6003, false)
    var numbers []int
    fmt.Println("Numbers n < 6000 where: n - 1, n + 3, n + 5 are all primes:")
    for n := 4; n < 6000; n += 2 {
        if !c[n-1] && !c[n+3] && !c[n+5] {
            numbers = append(numbers, n)
        }
    }
    for _, n := range numbers {
        fmt.Printf("%6s  => ", rcu.Commatize(n))
        for _, p := range []int{n - 1, n + 3, n + 5} {
            fmt.Printf("%6s ", rcu.Commatize(p))
        }
        fmt.Println()
    }
    fmt.Printf("\n%d such numbers found.\n", len(numbers))
}
