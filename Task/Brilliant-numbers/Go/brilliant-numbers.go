package main

import (
    "fmt"
    "math"
    "rcu"
    "sort"
)

var primes = rcu.Primes(1e8 - 1)

type res struct {
    bc   interface{}
    next int
}

func getBrilliant(digits, limit int, countOnly bool) res {
    var brilliant []int
    count := 0
    pow := 1
    next := math.MaxInt
    for k := 1; k <= digits; k++ {
        var s []int
        for _, p := range primes {
            if p >= pow*10 {
                break
            }
            if p > pow {
                s = append(s, p)
            }
        }
        for i := 0; i < len(s); i++ {
            for j := i; j < len(s); j++ {
                prod := s[i] * s[j]
                if prod < limit {
                    if countOnly {
                        count++
                    } else {
                        brilliant = append(brilliant, prod)
                    }
                } else {
                    if next > prod {
                        next = prod
                    }
                    break
                }
            }
        }
        pow *= 10
    }
    if countOnly {
        return res{count, next}
    }
    return res{brilliant, next}
}

func main() {
    fmt.Println("First 100 brilliant numbers:")
    brilliant := getBrilliant(2, 10000, false).bc.([]int)
    sort.Ints(brilliant)
    brilliant = brilliant[0:100]
    for i := 0; i < len(brilliant); i++ {
        fmt.Printf("%4d ", brilliant[i])
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }
    fmt.Println()
    for k := 1; k <= 13; k++ {
        limit := int(math.Pow(10, float64(k)))
        r := getBrilliant(k, limit, true)
        total := r.bc.(int)
        next := r.next
        climit := rcu.Commatize(limit)
        ctotal := rcu.Commatize(total + 1)
        cnext := rcu.Commatize(next)
        fmt.Printf("First >= %18s is %14s in the series: %18s\n", climit, ctotal, cnext)
    }
}
