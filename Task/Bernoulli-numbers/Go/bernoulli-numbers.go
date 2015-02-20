package main

import (
    "fmt"
    "math/big"
    "strings"
)

func b(n int) *big.Rat {
    var f big.Rat
    a := make([]big.Rat, n+1)
    for m := range a {
        a[m].SetFrac64(1, int64(m+1))
        for j := m; j >= 1; j-- {
            d := &a[j-1]
            d.Mul(f.SetInt64(int64(j)), d.Sub(d, &a[j]))
        }
    }
    return f.Set(&a[0])
}

func align(b *big.Rat, w int) string {
    s := b.String()
    return strings.Repeat(" ", w-strings.Index(s, "/")) + s
}

func main() {
    for n := 0; n <= 60; n++ {
        if b := b(n); b.Num().BitLen() > 0 {
            fmt.Printf("B(%2d) =%s\n", n, align(b, 45))
        }
    }
}
