package main

import "fmt"

func main() {
    h := []float64{-8, -9, -3, -1, -6, 7}
    f := []float64{-3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1}
    g := []float64{24, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96,
        96, 31, 55, 36, 29, -43, -7}
    fmt.Println(h)
    fmt.Println(deconv(g, f))
    fmt.Println(f)
    fmt.Println(deconv(g, h))
}

func deconv(g, f []float64) []float64 {
    h := make([]float64, len(g)-len(f)+1)
    for n := range h {
        h[n] = g[n]
        var lower int
        if n >= len(f) {
            lower = n - len(f) + 1
        }
        for i := lower; i < n; i++ {
            h[n] -= h[i] * f[n-i]
        }
        h[n] /= f[0]
    }
    return h
}
