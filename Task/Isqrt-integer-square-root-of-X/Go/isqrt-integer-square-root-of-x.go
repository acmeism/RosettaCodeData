package main

import (
    "fmt"
    "log"
    "math/big"
)

var zero = big.NewInt(0)
var one = big.NewInt(1)

func isqrt(x *big.Int) *big.Int {
    if x.Cmp(zero) < 0 {
        log.Fatal("Argument cannot be negative.")
    }
    q := big.NewInt(1)
    for q.Cmp(x) <= 0 {
        q.Lsh(q, 2)
    }
    z := new(big.Int).Set(x)
    r := big.NewInt(0)
    for q.Cmp(one) > 0 {
        q.Rsh(q, 2)
        t := new(big.Int)
        t.Add(t, z)
        t.Sub(t, r)
        t.Sub(t, q)
        r.Rsh(r, 1)
        if t.Cmp(zero) >= 0 {
            z.Set(t)
            r.Add(r, q)
        }
    }
    return r
}

func commatize(s string) string {
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    return s
}

func main() {
    fmt.Println("The integer square roots of integers from 0 to 65 are:")
    for i := int64(0); i <= 65; i++ {
        fmt.Printf("%d ", isqrt(big.NewInt(i)))
    }
    fmt.Println()
    fmt.Println("\nThe integer square roots of powers of 7 from 7^1 up to 7^73 are:\n")
    fmt.Println("power                                    7 ^ power                                                 integer square root")
    fmt.Println("----- --------------------------------------------------------------------------------- -----------------------------------------")
    pow7 := big.NewInt(7)
    bi49 := big.NewInt(49)
    for i := 1; i <= 73; i += 2 {
        fmt.Printf("%2d %84s %41s\n", i, commatize(pow7.String()), commatize(isqrt(pow7).String()))
        pow7.Mul(pow7, bi49)
    }
}
