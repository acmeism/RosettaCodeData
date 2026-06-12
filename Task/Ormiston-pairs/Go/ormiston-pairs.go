package main

import (
    "fmt"
    "rcu"
)

func main() {
    const limit = 1e9
    primes := rcu.Primes(int(limit))
    var orm30 [][2]int
    j := int(1e5)
    count := 0
    var counts []int
    for i := 0; i < len(primes)-1; i++ {
        p1 := primes[i]
        p2 := primes[i+1]
        if (p2-p1)%18 != 0 {
            continue
        }
        key1 := 1
        for _, dig := range rcu.Digits(p1, 10) {
            key1 *= primes[dig]
        }
        key2 := 1
        for _, dig := range rcu.Digits(p2, 10) {
            key2 *= primes[dig]
        }
        if key1 == key2 {
            if count < 30 {
                orm30 = append(orm30, [2]int{p1, p2})
            }
            if p1 >= j {
                counts = append(counts, count)
                j *= 10
            }
            count++
        }
    }
    counts = append(counts, count)
    fmt.Println("First 30 Ormiston pairs:")
    for i := 0; i < 30; i++ {
        fmt.Printf("%5v ", orm30[i])
        if (i+1)%3 == 0 {
            fmt.Println()
        }
    }
    fmt.Println()
    j = int(1e5)
    for i := 0; i < len(counts); i++ {
        fmt.Printf("%s Ormiston pairs before %s\n", rcu.Commatize(counts[i]), rcu.Commatize(j))
        j *= 10
    }
}
