package main

import (
    "fmt"
    "math/big"
)

func main() {
    limit := 100
    last := 12
    unsigned := true
    s1 := make([][]*big.Int, limit+1)
    for n := 0; n <= limit; n++ {
        s1[n] = make([]*big.Int, limit+1)
        for k := 0; k <= limit; k++ {
            s1[n][k] = new(big.Int)
        }
    }
    s1[0][0].SetInt64(int64(1))
    var t big.Int
    for n := 1; n <= limit; n++ {
        for k := 1; k <= n; k++ {
            t.SetInt64(int64(n - 1))
            t.Mul(&t, s1[n-1][k])
            if unsigned {
                s1[n][k].Add(s1[n-1][k-1], &t)
            } else {
                s1[n][k].Sub(s1[n-1][k-1], &t)
            }
        }
    }
    fmt.Println("Unsigned Stirling numbers of the first kind: S1(n, k):")
    fmt.Printf("n/k")
    for i := 0; i <= last; i++ {
        fmt.Printf("%9d ", i)
    }
    fmt.Printf("\n--")
    for i := 0; i <= last; i++ {
        fmt.Printf("----------")
    }
    fmt.Println()
    for n := 0; n <= last; n++ {
        fmt.Printf("%2d ", n)
        for k := 0; k <= n; k++ {
            fmt.Printf("%9d ", s1[n][k])
        }
        fmt.Println()
    }
    fmt.Println("\nMaximum value from the S1(100, *) row:")
    max := new(big.Int).Set(s1[limit][0])
    for k := 1; k <= limit; k++ {
        if s1[limit][k].Cmp(max) > 0 {
            max.Set(s1[limit][k])
        }
    }
    fmt.Println(max)
    fmt.Printf("which has %d digits.\n", len(max.String()))
}
