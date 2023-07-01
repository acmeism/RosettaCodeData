package main

import (
    "fmt"
    "log"
    "math/big"
)

func max(a, b *big.Float) *big.Float {
    if a.Cmp(b) > 0 {
        return a
    }
    return b
}

func isClose(a, b *big.Float) bool {
    relTol := big.NewFloat(1e-9) // same as default for Python's math.isclose() function
    t := new(big.Float)
    t.Sub(a, b)
    t.Abs(t)
    u, v, w := new(big.Float), new(big.Float), new(big.Float)
    u.Mul(relTol, max(v.Abs(a), w.Abs(b)))
    return t.Cmp(u) <= 0
}

func nbf(s string) *big.Float {
    n, ok := new(big.Float).SetString(s)
    if !ok {
        log.Fatal("invalid floating point number")
    }
    return n
}

func main() {
    root2 := big.NewFloat(2.0)
    root2.Sqrt(root2)
    pairs := [][2]*big.Float{
        {nbf("100000000000000.01"), nbf("100000000000000.011")},
        {nbf("100.01"), nbf("100.011")},
        {nbf("0").Quo(nbf("10000000000000.001"), nbf("10000.0")), nbf("1000000000.0000001000")},
        {nbf("0.001"), nbf("0.0010000001")},
        {nbf("0.000000000000000000000101"), nbf("0.0")},
        {nbf("0").Mul(root2, root2), nbf("2.0")},
        {nbf("0").Mul(nbf("0").Neg(root2), root2), nbf("-2.0")},
        {nbf("100000000000000003.0"), nbf("100000000000000004.0")},
        {nbf("3.14159265358979323846"), nbf("3.14159265358979324")},
    }
    for _, pair := range pairs {
        s := "≉"
        if isClose(pair[0], pair[1]) {
            s = "≈"
        }
        fmt.Printf("% 21.19g %s %- 21.19g\n", pair[0], s, pair[1])
    }
}
