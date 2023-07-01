package main

import (
    "fmt"
    "math/big"
)

func main() {
    one := big.NewFloat(1)
    two := big.NewFloat(2)
    four := big.NewFloat(4)
    prec := uint(768) // say

    a := big.NewFloat(1).SetPrec(prec)
    g := new(big.Float).SetPrec(prec)

    // temporary variables
    t := new(big.Float).SetPrec(prec)
    u := new(big.Float).SetPrec(prec)

    g.Quo(a, t.Sqrt(two))
    sum := new(big.Float)
    pow := big.NewFloat(2)

    for a.Cmp(g) != 0 {
        t.Add(a, g)
        t.Quo(t, two)
        g.Sqrt(u.Mul(a, g))
        a.Set(t)
        pow.Mul(pow, two)
        t.Sub(t.Mul(a, a), u.Mul(g, g))
        sum.Add(sum, t.Mul(t, pow))
    }

    t.Mul(a, a)
    t.Mul(t, four)
    pi := t.Quo(t, u.Sub(one, sum))
    fmt.Println(pi)
}
