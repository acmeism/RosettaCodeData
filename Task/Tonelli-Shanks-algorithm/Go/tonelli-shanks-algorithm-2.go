package main

import (
    "fmt"
    "math/big"
)

func ts(n, p big.Int) (R1, R2 big.Int, ok bool) {
    if big.Jacobi(&n, &p) != 1 {
        return
    }
    var one, Q big.Int
    one.SetInt64(1)
    Q.Sub(&p, &one)
    S := 0
    for Q.Bit(0) == 0 {
        S++
        Q.Rsh(&Q, 1)
    }
    if S == 1 {
        R1.Exp(&n, R1.Rsh(R1.Add(&p, &one), 2), &p)
        R2.Sub(&p, &R1)
        return R1, R2, true
    }
    var z, c big.Int
    for z.SetInt64(2); big.Jacobi(&z, &p) != -1; z.Add(&z, &one) {
    }
    c.Exp(&z, &Q, &p)
    var R, t big.Int
    R.Exp(&n, R.Rsh(R.Add(&Q, &one), 1), &p)
    t.Exp(&n, &Q, &p)
    M := S
    for {
        if t.Cmp(&one) == 0 {
            R2.Sub(&p, &R)
            return R, R2, true
        }
        i := 0
        // reuse z as a scratch variable
        for z.Set(&t); z.Cmp(&one) != 0 && i < M-1; {
            z.Mod(z.Mul(&z, &z), &p)
            i++
        }
        // and instead of a new scratch variable b, continue using z
        z.Set(&c)
        for e := M - i - 1; e > 0; e-- {
            z.Mod(z.Mul(&z, &z), &p)
        }
        R.Mod(R.Mul(&R, &z), &p)
        c.Mod(c.Mul(&z, &z), &p)
        t.Mod(t.Mul(&t, &c), &p)
        M = i
    }
}

func main() {
    var n, p big.Int
    n.SetInt64(665820697)
    p.SetInt64(1000000009)
    R1, R2, ok := ts(n, p)
    fmt.Println(&R1, &R2, ok)

    n.SetInt64(881398088036)
    p.SetInt64(1000000000039)
    R1, R2, ok = ts(n, p)
    fmt.Println(&R1, &R2, ok)
    n.SetString("41660815127637347468140745042827704103445750172002", 10)
    p.SetString("100000000000000000000000000000000000000000000000577", 10)
    R1, R2, ok = ts(n, p)
    fmt.Println(&R1)
    fmt.Println(&R2)
}
