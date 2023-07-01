package main

import (
    "fmt"
    "rcu"
)

func motzkin(n int) []int {
    m := make([]int, n+1)
    m[0] = 1
    m[1] = 1
    for i := 2; i <= n; i++ {
        m[i] = (m[i-1]*(2*i+1) + m[i-2]*(3*i-3)) / (i + 2)
    }
    return m
}

func main() {
    fmt.Println(" n          M[n]             Prime?")
    fmt.Println("-----------------------------------")
    m := motzkin(41)
    for i, e := range m {
        fmt.Printf("%2d  %23s  %t\n", i, rcu.Commatize(e), rcu.IsPrime(e))
    }
}
