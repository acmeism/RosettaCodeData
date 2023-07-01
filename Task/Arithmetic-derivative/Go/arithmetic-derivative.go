package main

import (
    "fmt"
    "rcu"
)

func D(n float64) float64 {
    if n < 0 {
        return -D(-n)
    }
    if n < 2 {
        return 0
    }
    var f []int
    if n < 1e19 {
        f = rcu.PrimeFactors(int(n))
    } else {
        g := int(n / 100)
        f = rcu.PrimeFactors(g)
        f = append(f, []int{2, 2, 5, 5}...)
    }
    c := len(f)
    if c == 1 {
        return 1
    }
    if c == 2 {
        return float64(f[0] + f[1])
    }
    d := n / float64(f[0])
    return D(d)*float64(f[0]) + d
}

func main() {
    ad := make([]int, 200)
    for n := -99; n < 101; n++ {
        ad[n+99] = int(D(float64(n)))
    }
    rcu.PrintTable(ad, 10, 4, false)
    fmt.Println()
    pow := 1.0
    for m := 1; m < 21; m++ {
        pow *= 10
        fmt.Printf("D(10^%-2d) / 7 = %.0f\n", m, D(pow)/7)
    }
}
