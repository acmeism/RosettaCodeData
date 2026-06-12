package main

import (
    "fmt"
    big "github.com/ncw/gmp"
    "time"
)

var (
    zero  = new(big.Int)
    one   = big.NewInt(1)
    two   = big.NewInt(2)
    three = big.NewInt(3)
)

func lucas(n *big.Int) *big.Int {
    var inner func(n *big.Int) (*big.Int, *big.Int)
    inner = func(n *big.Int) (*big.Int, *big.Int) {
        if n.Cmp(zero) == 0 {
            return new(big.Int), big.NewInt(1)
        }
        t, q, r := new(big.Int), new(big.Int), new(big.Int)
        u, v := inner(t.Rsh(n, 1))
        t.And(n, two)
        q.Sub(t, one)
        u.Mul(u, u)
        v.Mul(v, v)
        t.And(n, one)
        if t.Cmp(one) == 0 {
            t.Sub(u, q)
            t.Mul(two, t)
            r.Mul(three, v)
            return u.Add(u, v), r.Sub(r, t)
        } else {
            t.Mul(three, u)
            r.Add(v, q)
            r.Mul(two, r)
            return r.Sub(r, t), u.Add(u, v)
        }
    }
    t, q, l := new(big.Int), new(big.Int), new(big.Int)
    u, v := inner(t.Rsh(n, 1))
    l.Mul(two, v)
    l.Sub(l, u) // Lucas function
    t.And(n, one)
    if t.Cmp(one) == 0 {
        q.And(n, two)
        q.Sub(q, one)
        t.Mul(v, l)
        return t.Add(t, q)
    }
    return u.Mul(u, l)
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
        s := lucas(n).String()
        fmt.Printf("The digits of the %sth Fibonacci number (%s) are:\n",
            commatize(i), commatize(uint64(len(s))))
        if len(s) > 20 {
            fmt.Printf("  First 20 : %s\n", s[0:20])
            if len(s) < 40 {
                fmt.Printf("  Final %-2d : %s\n", len(s)-20, s[20:])
            } else {
                fmt.Printf("  Final 20 : %s\n", s[len(s)-20:])
            }
        } else {
            fmt.Printf("  All %-2d   : %s\n", len(s), s)
        }
        fmt.Println()
    }

    sfxs := []string{"nd", "th"}
    for i, e := range []uint{16, 32} {
        n.Lsh(one, e)
        s := lucas(n).String()
        fmt.Printf("The digits of the 2^%d%s Fibonacci number (%s) are:\n", e, sfxs[i],
            commatize(uint64(len(s))))
        fmt.Printf("  First 20 : %s\n", s[0:20])
        fmt.Printf("  Final 20 : %s\n", s[len(s)-20:])
        fmt.Println()
    }

    fmt.Printf("Took %s\n\n", time.Since(start))
}
