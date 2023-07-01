package main

import (
    "fmt"
    "math/big"
)

func main() {
    limit := 100
    last := 12
    unsigned := true
    l := make([][]*big.Int, limit+1)
    for n := 0; n <= limit; n++ {
        l[n] = make([]*big.Int, limit+1)
        for k := 0; k <= limit; k++ {
            l[n][k] = new(big.Int)
        }
        l[n][n].SetInt64(int64(1))
        if n != 1 {
            l[n][1].MulRange(int64(2), int64(n))
        }
    }
    var t big.Int
    for n := 1; n <= limit; n++ {
        for k := 1; k <= n; k++ {
            t.Mul(l[n][1], l[n-1][1])
            t.Quo(&t, l[k][1])
            t.Quo(&t, l[k-1][1])
            t.Quo(&t, l[n-k][1])
            l[n][k].Set(&t)
            if !unsigned && (n%2 == 1) {
                l[n][k].Neg(l[n][k])
            }
        }
    }
    fmt.Println("Unsigned Lah numbers: l(n, k):")
    fmt.Printf("n/k")
    for i := 0; i <= last; i++ {
        fmt.Printf("%10d ", i)
    }
    fmt.Printf("\n--")
    for i := 0; i <= last; i++ {
        fmt.Printf("-----------")
    }
    fmt.Println()
    for n := 0; n <= last; n++ {
        fmt.Printf("%2d ", n)
        for k := 0; k <= n; k++ {
            fmt.Printf("%10d ", l[n][k])
        }
        fmt.Println()
    }
    fmt.Println("\nMaximum value from the l(100, *) row:")
    max := new(big.Int).Set(l[limit][0])
    for k := 1; k <= limit; k++ {
        if l[limit][k].Cmp(max) > 0 {
            max.Set(l[limit][k])
        }
    }
    fmt.Println(max)
    fmt.Printf("which has %d digits.\n", len(max.String()))
}
