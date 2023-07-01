package main

import (
    "fmt"
    "math/big"
)

func main() {
    limit := 100
    last := 12
    s2 := make([][]*big.Int, limit+1)
    for n := 0; n <= limit; n++ {
        s2[n] = make([]*big.Int, limit+1)
        for k := 0; k <= limit; k++ {
            s2[n][k] = new(big.Int)
        }
        s2[n][n].SetInt64(int64(1))
    }
    var t big.Int
    for n := 1; n <= limit; n++ {
        for k := 1; k <= n; k++ {
            t.SetInt64(int64(k))
            t.Mul(&t, s2[n-1][k])
            s2[n][k].Add(&t, s2[n-1][k-1])
        }
    }
    fmt.Println("Stirling numbers of the second kind: S2(n, k):")
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
            fmt.Printf("%9d ", s2[n][k])
        }
        fmt.Println()
    }
    fmt.Println("\nMaximum value from the S2(100, *) row:")
    max := new(big.Int).Set(s2[limit][0])
    for k := 1; k <= limit; k++ {
        if s2[limit][k].Cmp(max) > 0 {
            max.Set(s2[limit][k])
        }
    }
    fmt.Println(max)
    fmt.Printf("which has %d digits.\n", len(max.String()))
}
