package main

import (
    "fmt"
    "math"
    "rcu"
)

var limit = int(math.Log(1e6) * 1e6 * 1.2) // should be more than enough
var primes = rcu.Primes(limit)

var prevCats = make(map[int]int)

func cat(p int) int {
    if v, ok := prevCats[p]; ok {
        return v
    }
    pf := rcu.PrimeFactors(p + 1)
    all := true
    for _, f := range pf {
        if f != 2 && f != 3 {
            all = false
            break
        }
    }
    if all {
        return 1
    }
    if p > 2 {
        len := len(pf)
        for i := len - 1; i >= 1; i-- {
            if pf[i-1] == pf[i] {
                pf = append(pf[:i], pf[i+1:]...)
            }
        }
    }
    for c := 2; c <= 11; c++ {
        all := true
        for _, f := range pf {
            if cat(f) >= c {
                all = false
                break
            }
        }
        if all {
            prevCats[p] = c
            return c
        }
    }
    return 12
}

func main() {
    es := make([][]int, 12)
    fmt.Println("First 200 primes:\n")
    for _, p := range primes[0:200] {
        c := cat(p)
        es[c-1] = append(es[c-1], p)
    }
    for c := 1; c <= 6; c++ {
        if len(es[c-1]) > 0 {
            fmt.Println("Category", c, "\b:")
            fmt.Println(es[c-1])
            fmt.Println()
        }
    }

    fmt.Println("First million primes:\n")
    for _, p := range primes[200:1e6] {
        c := cat(p)
        es[c-1] = append(es[c-1], p)
    }
    for c := 1; c <= 12; c++ {
        e := es[c-1]
        if len(e) > 0 {
            format := "Category %-2d: First = %7d  Last = %8d  Count = %6d\n"
            fmt.Printf(format, c, e[0], e[len(e)-1], len(e))
        }
    }
}
