package main

import (
    "fmt"
    "math/big"
)

func main() {
    ln2, _ := new(big.Rat).SetString("0.6931471805599453094172")
    h := big.NewRat(1, 2)
    h.Quo(h, ln2)
    var f big.Rat
    var w big.Int
    for i := int64(1); i <= 17; i++ {
        h.Quo(h.Mul(h, f.SetInt64(i)), ln2)
        w.Quo(h.Num(), h.Denom())
        f.Sub(h, f.SetInt(&w))
        y, _ := f.Float64()
        d := fmt.Sprintf("%.3f", y)
        fmt.Printf("n: %2d  h: %18d%s  Nearly integer: %t\n",
            i, &w, d[1:], d[2] == '0' || d[2] == '9')
    }
}
