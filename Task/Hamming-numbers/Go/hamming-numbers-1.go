package main

import (
    "fmt"
    "math/big"
)

func min(a, b *big.Int) *big.Int {
    if a.Cmp(b) < 0 {
        return a
    }
    return b
}

func hamming(n int) []*big.Int {
    h := make([]*big.Int, n)
    h[0] = big.NewInt(1)
    two, three, five    := big.NewInt(2), big.NewInt(3), big.NewInt(5)
    next2, next3, next5 := big.NewInt(2), big.NewInt(3), big.NewInt(5)
    i, j, k := 0, 0, 0
    for m := 1; m < len(h); m++ {
        h[m] = new(big.Int).Set(min(next2, min(next3, next5)))
        if h[m].Cmp(next2) == 0 { i++; next2.Mul(  two, h[i]) }
        if h[m].Cmp(next3) == 0 { j++; next3.Mul(three, h[j]) }
        if h[m].Cmp(next5) == 0 { k++; next5.Mul( five, h[k]) }
    }
    return h
}

func main() {
    h := hamming(1e6)
    fmt.Println(h[:20])
    fmt.Println(h[1691-1])
    fmt.Println(h[len(h)-1])
}
