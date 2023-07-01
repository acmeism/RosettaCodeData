package main

import (
    "fmt"
    "math/big"
)

var (
    b1  = big.NewInt(1)
    b3  = big.NewInt(3)
    b5  = big.NewInt(5)
    b10 = big.NewInt(10)
    b15 = big.NewInt(15)
    b20 = big.NewInt(20)
)

func main() {
    fmt.Println(s35(new(big.Int).Exp(b10, b3, nil)))
    fmt.Println(s35(new(big.Int).Exp(b10, b20, nil)))
}

func s35(i *big.Int) *big.Int {
    j := new(big.Int).Sub(i, b1)
    sum2 := func(d *big.Int) *big.Int {
        n := new(big.Int).Quo(j, d)
        p := new(big.Int).Add(n, b1)
        return p.Mul(d, p.Mul(p, n))
    }
    s := sum2(b3)
    return s.Rsh(s.Sub(s.Add(s, sum2(b5)), sum2(b15)), 1)
}
