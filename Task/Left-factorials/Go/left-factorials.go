package main

import (
    "fmt"
    "math/big"
)

func main() {
    fmt.Print("!0 through !10: 0")
    one := big.NewInt(1)
    n := big.NewInt(1)
    f := big.NewInt(1)
    l := big.NewInt(1)
    next := func() { f.Mul(f, n); l.Add(l, f); n.Add(n, one) }
    for ; ; next() {
        fmt.Print(" ", l)
        if n.Int64() == 10 {
            break
        }
    }
    fmt.Println()
    for {
        for i := 0; i < 10; i++ {
            next()
        }
        fmt.Printf("!%d: %d\n", n, l)
        if n.Int64() == 110 {
            break
        }
    }
    fmt.Println("Lengths of !1000 through !10000 by thousands:")
    for i := 110; i < 1000; i++ {
        next()
    }
    for {
        fmt.Print(" ", len(l.String()))
        if n.Int64() == 10000 {
            break
        }
        for i := 0; i < 1000; i++ {
            next()
        }
    }
    fmt.Println()
}
