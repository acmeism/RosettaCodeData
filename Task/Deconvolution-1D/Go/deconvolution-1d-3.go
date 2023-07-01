package main

import (
    "fmt"

    "gonum.org/v1/gonum/mat"
)

var (
    h = []float64{-8, -9, -3, -1, -6, 7}
    f = []float64{-3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1}
    g = []float64{24, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96,
        96, 31, 55, 36, 29, -43, -7}
)

func band(g, f []float64) *mat.Dense {
    nh := len(g) - len(f) + 1
    b := mat.NewDense(len(g), nh, nil)
    for j := 0; j < nh; j++ {
        for i, fi := range f {
            b.Set(i+j, j, fi)
        }
    }
    return b
}

func deconv(g, f []float64) mat.Matrix {
    z := mat.NewDense(len(g)-len(f)+1, 1, nil)
    z.Solve(band(g, f), mat.NewVecDense(len(g), g))
    return z
}

func main() {
    fmt.Printf("deconv(g, f) =\n%.1f\n\n", mat.Formatted(deconv(g, f)))
    fmt.Printf("deconv(g, h) =\n%.1f\n", mat.Formatted(deconv(g, h)))
}
