package main

import (
    "fmt"
    "rcu"
    "sort"
)

func main() {
    const limit = int(1e10)
    const maxIndex = 9
    primes := rcu.Primes(limit)
    anaprimes := make(map[int][]int)
    for _, p := range primes {
        digs := rcu.Digits(p, 10)
        key := 1
        for _, dig := range digs {
            key *= primes[dig]
        }
        if _, ok := anaprimes[key]; ok {
            anaprimes[key] = append(anaprimes[key], p)
        } else {
            anaprimes[key] = []int{p}
        }
    }
    largest := make([]int, maxIndex+1)
    groups := make([][][]int, maxIndex+1)
    for key := range anaprimes {
        v := anaprimes[key]
        nd := len(rcu.Digits(v[0], 10))
        c := len(v)
        if c > largest[nd-1] {
            largest[nd-1] = c
            groups[nd-1] = [][]int{v}
        } else if c == largest[nd-1] {
            groups[nd-1] = append(groups[nd-1], v)
        }
    }
    j := 1000
    for i := 2; i <= maxIndex; i++ {
        js := rcu.Commatize(j)
        ls := rcu.Commatize(largest[i])
        fmt.Printf("Largest group(s) of anaprimes before %s: %s members:\n", js, ls)
        sort.Slice(groups[i], func(k, l int) bool {
            return groups[i][k][0] < groups[i][l][0]
        })
        for _, g := range groups[i] {
            fmt.Printf("  First: %s  Last: %s\n", rcu.Commatize(g[0]), rcu.Commatize(g[len(g)-1]))
        }
        j *= 10
        fmt.Println()
    }
}
