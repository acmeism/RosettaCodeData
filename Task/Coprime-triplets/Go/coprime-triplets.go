package main

import (
    "fmt"
    "rcu"
)

func contains(a []int, v int) bool {
    for _, e := range a {
        if e == v {
            return true
        }
    }
    return false
}

func main() {
    const limit = 50
    cpt := []int{1, 2}
    for {
        m := 1
        l := len(cpt)
        for contains(cpt, m) || rcu.Gcd(m, cpt[l-1]) != 1 || rcu.Gcd(m, cpt[l-2]) != 1 {
            m++
        }
        if m >= limit {
            break
        }
        cpt = append(cpt, m)
    }
    fmt.Printf("Coprime triplets under %d:\n", limit)
    for i, t := range cpt {
        fmt.Printf("%2d ", t)
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }
    fmt.Printf("\n\nFound %d such numbers\n", len(cpt))
}
