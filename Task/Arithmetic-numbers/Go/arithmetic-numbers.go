package main

import (
    "fmt"
    "math"
    "rcu"
    "sort"
)

func main() {
    arithmetic := []int{1}
    primes := []int{}
    limit := int(1e6)
    for n := 3; len(arithmetic) < limit; n++ {
        divs := rcu.Divisors(n)
        if len(divs) == 2 {
            primes = append(primes, n)
            arithmetic = append(arithmetic, n)
        } else {
            mean := float64(rcu.SumInts(divs)) / float64(len(divs))
            if mean == math.Trunc(mean) {
                arithmetic = append(arithmetic, n)
            }
        }
    }
    fmt.Println("The first 100 arithmetic numbers are:")
    rcu.PrintTable(arithmetic[0:100], 10, 3, false)

    for _, x := range []int{1e3, 1e4, 1e5, 1e6} {
        last := arithmetic[x-1]
        lastc := rcu.Commatize(last)
        fmt.Printf("\nThe %sth arithmetic number is: %s\n", rcu.Commatize(x), lastc)
        pcount := sort.SearchInts(primes, last) + 1
        if !rcu.IsPrime(last) {
            pcount--
        }
        comp := x - pcount - 1 // 1 is not composite
        compc := rcu.Commatize(comp)
        fmt.Printf("The count of such numbers <= %s which are composite is %s.\n", lastc, compc)
    }
}
