package main

import "fmt"

type rangeBounds struct {
    b1, b2 float64
}

func mapRange(x, y rangeBounds, n float64) float64 {
    return y.b1 + (n - x.b1) * (y.b2 - y.b1) / (x.b2 - x.b1)
}

func main() {
    r1 := rangeBounds{0, 10}
    r2 := rangeBounds{-1, 0}
    for n := float64(0); n <= 10; n += 2 {
        fmt.Println(n, "maps to", mapRange(r1, r2, n))
    }
}
