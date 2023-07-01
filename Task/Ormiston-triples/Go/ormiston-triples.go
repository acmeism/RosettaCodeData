package main

import (
    "fmt"
    "rcu"
)

func main() {
    const limit = 1e10
    primes := rcu.Primes(limit)
    var orm25 []int
    j := int(1e9)
    count := 0
    var counts []int
    for i := 0; i < len(primes)-2; i++ {
        p1 := primes[i]
        p2 := primes[i+1]
        p3 := primes[i+2]
        if (p2-p1)%18 != 0 || (p3-p2)%18 != 0 {
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
        if key1 != key2 {
            continue
        }
        key3 := 1
        for _, dig := range rcu.Digits(p3, 10) {
            key3 *= primes[dig]
        }
        if key2 == key3 {
            if count < 25 {
                orm25 = append(orm25, p1)
            }
            if p1 >= j {
                counts = append(counts, count)
                j *= 10
            }
            count++
        }
    }
    counts = append(counts, count)
    fmt.Println("Smallest members of first 25 Ormiston triples:")
    for i := 0; i < 25; i++ {
        fmt.Printf("%8v ", orm25[i])
        if (i+1)%5 == 0 {
            fmt.Println()
        }
    }
    fmt.Println()
    j = int(1e9)
    for i := 0; i < len(counts); i++ {
        fmt.Printf("%s Ormiston triples before %s\n", rcu.Commatize(counts[i]), rcu.Commatize(j))
        j *= 10
        fmt.Println()
    }
}
