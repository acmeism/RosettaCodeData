package main

import (
    "fmt"
    "math/big"
)

func main() {
    fmt.Println(root(3, "8"))
    fmt.Println(root(3, "9"))
    fmt.Println(root(2, "2000000000000000000"))
    fmt.Println(root(2, "200000000000000000000000000000000000000000000000000"))
}

var one = big.NewInt(1)

func root(N int, X string) *big.Int {
    var xx, x, Δr big.Int
    xx.SetString(X, 10)
    nn := big.NewInt(int64(N))
    for r := big.NewInt(1); ; {
        x.Set(&xx)
        for i := 1; i < N; i++ {
            x.Quo(&x, r)
        }
        // big.Quo performs Go-like truncated division and would allow direct
        // translation of the int-based solution, but package big also provides
        // Div which performs Euclidean rather than truncated division.
        // This gives the desired result for negative x so the int-based
        // correction is no longer needed and the code here can more directly
        // follow the Wikipedia article.
        Δr.Div(x.Sub(&x, r), nn)
        if len(Δr.Bits()) == 0 {
            return r
        }
        r.Add(r, &Δr)
    }
}
