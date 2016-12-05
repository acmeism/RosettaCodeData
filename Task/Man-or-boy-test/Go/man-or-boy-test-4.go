package main

import (
    "fmt"
    "math/big"
)

func A(k int) *big.Int {
    one := big.NewInt(1)
    c0 := big.NewInt(3)
    c1 := big.NewInt(2)
    c2 := big.NewInt(1)
    c3 := big.NewInt(0)
    for j := 5; j < k; j++ {
        c3.Sub(c3.Add(c3, c0), one)
        c0.Add(c0, c1)
        c1.Add(c1, c2)
        c2.Add(c2, c3)
    }
    return c0.Add(c0.Sub(c0.Sub(c0, c1), c2), c3)
}

func p(k int) {
    fmt.Printf("A(%d) = ", k)
    if s := A(k).String(); len(s) < 60 {
        fmt.Println(s)
    } else {
        fmt.Printf("%s...%s (%d digits)\n",
            s[:6], s[len(s)-5:], len(s)-1)
    }
}

func main() {
    p(10)
    p(30)
    p(500)
    p(10000)
    p(1e6)
}
