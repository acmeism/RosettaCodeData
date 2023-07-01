package main

import (
    "fmt"
    "math/rand"
)

var (
    pList = []float64{.1, .3, .5, .7, .9}
    nList = []int{1e2, 1e3, 1e4, 1e5}
    t     = 100
)

func main() {
    for _, p := range pList {
        theory := p * (1 - p)
        fmt.Printf("\np: %.4f  theory: %.4f  t: %d\n", p, theory, t)
        fmt.Println("        n          sim     sim-theory")
        for _, n := range nList {
            sum := 0
            for i := 0; i < t; i++ {
                run := false
                for j := 0; j < n; j++ {
                    one := rand.Float64() < p
                    if one && !run {
                        sum++
                    }
                    run = one
                }
            }
            K := float64(sum) / float64(t) / float64(n)
            fmt.Printf("%9d %15.4f %9.6f\n", n, K, K-theory)
        }
    }
}
