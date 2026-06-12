package main

import (
    "fmt"
    "math"
    "rcu"
)

func isForbidden(n int) bool {
    m := n
    v := 0
    for m > 1 && m%4 == 0 {
        m /= 4
        v++
    }
    pow := int(math.Pow(4, float64(v)))
    return n/pow%8 == 7
}

func main() {
    forbidden := make([]int, 50)
    for i, count := 0, 0; count < 50; i++ {
        if isForbidden(i) {
            forbidden[count] = i
            count++
        }
    }
    fmt.Println("The first 50 forbidden numbers are:")
    rcu.PrintTable(forbidden, 10, 3, false)
    fmt.Println()
    limit := 500
    count := 0
    for i := 1; ; i++ {
        if isForbidden(i) {
            count++
        }
        if i == limit {
            slimit := rcu.Commatize(limit)
            scount := rcu.Commatize(count)
            fmt.Printf("Forbidden number count <= %11s: %10s\n", slimit, scount)
            if limit == 500_000_000 {
                return
            }
            limit *= 10
        }
    }
}
