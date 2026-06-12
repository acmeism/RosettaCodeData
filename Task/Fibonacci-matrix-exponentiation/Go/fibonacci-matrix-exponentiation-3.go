package main

import (
    "fmt"
    "github.com/ALTree/bigfloat"
    "github.com/ncw/gmp"
    "math/big"
    "time"
)

const (
    nd = 20  // number of digits to be displayed at each end
    pr = 128 // precision to be used
)

var (
    one  = gmp.NewInt(1)
    two  = gmp.NewInt(2)
    ten  = gmp.NewInt(10)
    onef = big.NewFloat(1).SetPrec(pr)
    tenf = big.NewFloat(10).SetPrec(pr)
    ln10 = bigfloat.Log(tenf)
)

func fibmod(n, nmod *gmp.Int) *gmp.Int {
    if n.Cmp(two) < 0 {
        return n
    }
    fibmods := make(map[string]*gmp.Int)
    var f func(n *gmp.Int) *gmp.Int
    f = func(n *gmp.Int) *gmp.Int {
        if n.Cmp(two) < 0 {
            return one
        }
        ns := n.String()
        if v, ok := fibmods[ns]; ok {
            return v
        }
        k, t, u, v := new(gmp.Int), new(gmp.Int), new(gmp.Int), new(gmp.Int)
        k.Quo(n, two)
        t.And(n, one)
        if t.Cmp(one) != 0 {
            t.Set(f(k))
            t.Mul(t, t)
            v.Sub(k, one)
            u.Set(f(v))
            u.Mul(u, u)
        } else {
            t.Set(f(k))
            v.Add(k, one)
            v.Set(f(v))
            u.Sub(k, one)
            u.Set(f(u))
            u.Mul(u, t)
            t.Mul(t, v)
        }
        t.Add(t, u)
        fibmods[ns] = t.Rem(t, nmod)
        return fibmods[ns]
    }
    w := new(gmp.Int)
    w.Sub(n, one)
    return f(w)
}

func binetApprox(n *big.Int) *big.Float {
    phi, ihp := big.NewFloat(0.5).SetPrec(pr), big.NewFloat(0.5).SetPrec(pr)
    root := big.NewFloat(1.25).SetPrec(pr)
    root.Sqrt(root)
    phi.Add(root, phi)
    ihp.Sub(root, ihp)
    ihp.Neg(ihp)
    ihp.Sub(phi, ihp)
    ihp = bigfloat.Log(ihp)
    phi = bigfloat.Log(phi)
    nn := new(big.Float).SetPrec(pr).SetInt(n)
    phi.Mul(phi, nn)
    return phi.Sub(phi, ihp)
}

func firstFibDigits(n *big.Int, k int) string {
    f := binetApprox(n)
    g := new(big.Float).SetPrec(pr)
    g.Quo(f, ln10)
    g.Add(g, onef)
    i, _ := g.Int(nil)
    g.SetInt(i)
    g.Mul(ln10, g)
    f.Sub(f, g)
    f = bigfloat.Exp(f)
    p := big.NewInt(int64(k))
    p.Exp(big.NewInt(10), p, nil)
    g.SetInt(p)
    f.Mul(f, g)
    i, _ = f.Int(nil)
    return i.String()[0:k]
}

func lastFibDigits(n *gmp.Int, k int) string {
    p := gmp.NewInt(int64(k))
    p.Exp(ten, p, nil)
    return fibmod(n, p).String()[0:k]
}

func commatize(n uint64) string {
    s := fmt.Sprintf("%d", n)
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    return s
}

func main() {
    start := time.Now()
    n := new(big.Int)
    for i := uint64(10); i <= 1e7; i *= 10 {
        n.SetUint64(i)
        nn := new(gmp.Int)
        nn.SetUint64(i)
        fmt.Printf("\nThe digits of the %sth Fibonacci number are:\n", commatize(i))
        nd2, nd3 := nd, nd
        // These need to be preset for i == 10 & i == 100
        // as there is no way of deriving the total length of the string using this method.
        if i == 10 {
            nd2 = 2
        } else if i == 100 {
            nd3 = 1
        }
        s1 := firstFibDigits(n, nd2)
        if len(s1) < 20 {
            fmt.Printf("  All %-2d   : %s\n", len(s1), s1)
        } else {
            fmt.Printf("  First 20 : %s\n", s1)
            s2 := lastFibDigits(nn, nd3)
            if len(s2) < 20 {
                fmt.Printf("  Final %-2d : %s\n", len(s2), s2)
            } else {
                fmt.Printf("  Final 20 : %s\n", s2)
            }
        }
    }

    o := big.NewInt(1)
    ord := []string{"th", "nd", "th"}
    for i, p := range []uint{16, 32, 64} {
        n.Lsh(o, p)
        nn := new(gmp.Int)
        nn.Lsh(one, p)
        fmt.Printf("\nThe digits of the 2^%d%s Fibonacci number are:\n", p, ord[i])
        fmt.Printf("  First %d : %s\n", nd, firstFibDigits(n, nd))
        fmt.Printf("  Final %d : %s\n", nd, lastFibDigits(nn, nd))
    }
    fmt.Printf("\nTook %s\n", time.Since(start))
}
