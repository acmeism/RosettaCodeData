package main

import (
    "fmt"
    "math"
    "rcu"
    "sort"
)

func main() {
    const limit = 1000000
    limit2 := int(math.Cbrt(limit))
    primes := rcu.Primes(limit / 6)
    pc := len(primes)
    var sphenic []int
    fmt.Println("Sphenic numbers less than 1,000:")
    for i := 0; i < pc-2; i++ {
        if primes[i] > limit2 {
            break
        }
        for j := i + 1; j < pc-1; j++ {
            prod := primes[i] * primes[j]
            if prod+primes[j+1] >= limit {
                break
            }
            for k := j + 1; k < pc; k++ {
                res := prod * primes[k]
                if res >= limit {
                    break
                }
                sphenic = append(sphenic, res)
            }
        }
    }
    sort.Ints(sphenic)
    ix := sort.Search(len(sphenic), func(i int) bool { return sphenic[i] >= 1000 })
    rcu.PrintTable(sphenic[:ix], 15, 3, false)
    fmt.Println("\nSphenic triplets less than 10,000:")
    var triplets [][3]int
    for i := 0; i < len(sphenic)-2; i++ {
        s := sphenic[i]
        if sphenic[i+1] == s+1 && sphenic[i+2] == s+2 {
            triplets = append(triplets, [3]int{s, s + 1, s + 2})
        }
    }
    ix = sort.Search(len(triplets), func(i int) bool { return triplets[i][2] >= 10000 })
    for i := 0; i < ix; i++ {
        fmt.Printf("%4d ", triplets[i])
        if (i+1)%3 == 0 {
            fmt.Println()
        }
    }
    fmt.Printf("\nThere are %s sphenic numbers less than 1,000,000.\n", rcu.Commatize(len(sphenic)))
    fmt.Printf("There are %s sphenic triplets less than 1,000,000.\n", rcu.Commatize(len(triplets)))
    s := sphenic[199999]
    pf := rcu.PrimeFactors(s)
    fmt.Printf("The 200,000th sphenic number is %s (%d*%d*%d).\n", rcu.Commatize(s), pf[0], pf[1], pf[2])
    fmt.Printf("The 5,000th sphenic triplet is %v.\n.", triplets[4999])
}
