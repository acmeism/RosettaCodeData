package main

import (
    "fmt"
    "github.com/ALTree/bigfloat"
    "math/big"
)

const (
    prec = 256 // say
    ps   = "3.1415926535897932384626433832795028841971693993751058209749445923078164"
)

func q(d int64) *big.Float {
    pi, _ := new(big.Float).SetPrec(prec).SetString(ps)
    t := new(big.Float).SetPrec(prec).SetInt64(d)
    t.Sqrt(t)
    t.Mul(pi, t)
    return bigfloat.Exp(t)
}

func main() {
    fmt.Println("Ramanujan's constant to 32 decimal places is:")
    fmt.Printf("%.32f\n", q(163))
    heegners := [4][2]int64{
        {19, 96},
        {43, 960},
        {67, 5280},
        {163, 640320},
    }
    fmt.Println("\nHeegner numbers yielding 'almost' integers:")
    t := new(big.Float).SetPrec(prec)
    for _, h := range heegners {
        qh := q(h[0])
        c := h[1]*h[1]*h[1] + 744
        t.SetInt64(c)
        t.Sub(t, qh)
        fmt.Printf("%3d: %51.32f ≈ %18d (diff: %.32f)\n", h[0], qh, c, t)
    }
}
