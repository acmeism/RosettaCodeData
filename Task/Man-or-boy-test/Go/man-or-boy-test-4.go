package main

import (
    "fmt"
    "math/big"
)

func A(k int) *big.Int {
    if k < 6 {
        var x1, x2, x3, x4 int64 = 1, -1, -1, 1
        c1 := []int64{0, 0, 0, 1, 2, 3}[k]
        c2 := []int64{0, 0, 1, 1, 1, 2}[k]
        c3 := []int64{0, 1, 1, 0, 0, 1}[k]
        c4 := []int64{1, 1, 0, 0, 0, 0}[k]
        t := c1*x1 + c2*x2 + c3*x3 + c4*x4
        return big.NewInt(t)
    }
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
    for i := 0; i < 40; i++ {
        p(i)
    }
    p(500)
    p(10000)
    p(1e6)
}
