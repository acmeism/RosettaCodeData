package main

import (
    "fmt"
    "rcu"
    "sort"
)

func main() {
    var pows []int
    for a := 2; a <= 5; a++ {
        pow := a
        for b := 2; b <= 5; b++ {
            pow *= a
            pows = append(pows, pow)
        }
    }
    set := make(map[int]bool)
    for _, e := range pows {
        set[e] = true
    }
    pows = pows[:0]
    for k := range set {
        pows = append(pows, k)
    }
    sort.Ints(pows)
    fmt.Println("Ordered distinct values of a ^ b for a in [2..5] and b in [2..5]:")
    for i, pow := range pows {
        fmt.Printf("%5s ", rcu.Commatize(pow))
        if (i+1)%5 == 0 {
            fmt.Println()
        }
    }
    fmt.Println("\nFound", len(pows), "such numbers.")
}
