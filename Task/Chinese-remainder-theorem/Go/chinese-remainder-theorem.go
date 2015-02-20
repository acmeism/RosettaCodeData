package main

import (
    "fmt"
    "math/big"
)

var one = big.NewInt(1)

func crt(a, n []*big.Int) (*big.Int, error) {
    p := new(big.Int).Set(n[0])
    for _, n1 := range n[1:] {
        p.Mul(p, n1)
    }
    var x, q, s, z big.Int
    for i, n1 := range n {
        q.Div(p, n1)
        z.GCD(nil, &s, n1, &q)
        if z.Cmp(one) != 0 {
            return nil, fmt.Errorf("%d not coprime", n1)
        }
        x.Add(&x, s.Mul(a[i], s.Mul(&s, &q)))
    }
    return x.Mod(&x, p), nil
}

func main() {
    n := []*big.Int{
        big.NewInt(3),
        big.NewInt(5),
        big.NewInt(7),
    }
    a := []*big.Int{
        big.NewInt(2),
        big.NewInt(3),
        big.NewInt(2),
    }
    fmt.Println(crt(a, n))
}
