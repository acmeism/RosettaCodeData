package main

import (
    "fmt"
    "math/big"
)

func div(dividend, divisor []*big.Rat) (quotient, remainder []*big.Rat) {
    out := make([]*big.Rat, len(dividend))
    for i, c := range dividend {
        out[i] = new(big.Rat).Set(c)
    }
    for i := 0; i < len(dividend)-(len(divisor)-1); i++ {
        out[i].Quo(out[i], divisor[0])
        if coef := out[i]; coef.Sign() != 0 {
            var a big.Rat
            for j := 1; j < len(divisor); j++ {
                out[i+j].Add(out[i+j], a.Mul(a.Neg(divisor[j]), coef))
            }
        }
    }
    separator := len(out) - (len(divisor) - 1)
    return out[:separator], out[separator:]
}

func main() {
    N := []*big.Rat{
        big.NewRat(1, 1),
        big.NewRat(-12, 1),
        big.NewRat(0, 1),
        big.NewRat(-42, 1)}
    D := []*big.Rat{big.NewRat(1, 1), big.NewRat(-3, 1)}
    Q, R := div(N, D)
    fmt.Printf("%v / %v = %v remainder %v\n", N, D, Q, R)
}
