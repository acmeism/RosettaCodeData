package main

import (
    "fmt"
    "rcu"
    "sort"
    "strconv"
)

func combinations(a []int, k int) [][]int {
    n := len(a)
    c := make([]int, k)
    var combs [][]int
    var combine func(start, end, index int)
    combine = func(start, end, index int) {
        if index == k {
            t := make([]int, len(c))
            copy(t, c)
            combs = append(combs, t)
            return
        }
        for i := start; i <= end && end-i+1 >= k-index; i++ {
            c[index] = a[i]
            combine(i+1, end, index+1)
        }
    }
    combine(0, n-1, 0)
    return combs
}

func powerset(a []int) (res [][]int) {
    if len(a) == 0 {
        return
    }
    for i := 1; i <= len(a); i++ {
        res = append(res, combinations(a, i)...)
    }
    return
}

func main() {
    ps := powerset([]int{9, 8, 7, 6, 5, 4, 3, 2, 1})
    var descPrimes []int
    for i := 1; i < len(ps); i++ {
        s := ""
        for _, e := range ps[i] {
            s += string(e + '0')
        }
        p, _ := strconv.Atoi(s)
        if rcu.IsPrime(p) {
            descPrimes = append(descPrimes, p)
        }
    }
    sort.Ints(descPrimes)
    fmt.Println("There are", len(descPrimes), "descending primes, namely:")
    for i := 0; i < len(descPrimes); i++ {
        fmt.Printf("%8d ", descPrimes[i])
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }
    fmt.Println()
}
