package main

import (
    "fmt"
    "math/big"
)

var big1 = new(big.Int).SetUint64(1)

func solvePell(nn uint64) (*big.Int, *big.Int) {
    n := new(big.Int).SetUint64(nn)
    x := new(big.Int).Set(n)
    x.Sqrt(x)
    y := new(big.Int).Set(x)
    z := new(big.Int).SetUint64(1)
    r := new(big.Int).Lsh(x, 1)

    e1 := new(big.Int).SetUint64(1)
    e2 := new(big.Int)
    f1 := new(big.Int)
    f2 := new(big.Int).SetUint64(1)

    t := new(big.Int)
    u := new(big.Int)
    a := new(big.Int)
    b := new(big.Int)
    for {
        t.Mul(r, z)
        y.Sub(t, y)
        t.Mul(y, y)
        t.Sub(n, t)
        z.Quo(t, z)
        t.Add(x, y)
        r.Quo(t, z)
        u.Set(e1)
        e1.Set(e2)
        t.Mul(r, e2)
        e2.Add(t, u)
        u.Set(f1)
        f1.Set(f2)
        t.Mul(r, f2)
        f2.Add(t, u)
        t.Mul(x, f2)
        a.Add(e2, t)
        b.Set(f2)
        t.Mul(a, a)
        u.Mul(n, b)
        u.Mul(u, b)
        t.Sub(t, u)
        if t.Cmp(big1) == 0 {
            return a, b
        }
    }
}

func main() {
    ns := []uint64{61, 109, 181, 277}
    for _, n := range ns {
        x, y := solvePell(n)
        fmt.Printf("x^2 - %3d*y^2 = 1 for x = %-21s and y = %s\n", n, x, y)
    }
}
