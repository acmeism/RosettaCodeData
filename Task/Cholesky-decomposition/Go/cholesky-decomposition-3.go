package main

import (
    "fmt"

    "github.com/gonum/matrix/mat64"
)

func cholesky(order int, elements []float64) fmt.Formatter {
    t := mat64.NewTriDense(order, false, nil)
    t.Cholesky(mat64.NewSymDense(order, elements), false)
    return mat64.Formatted(t)
}

func main() {
    fmt.Println(cholesky(3, []float64{
        25, 15, -5,
        15, 18, 0,
        -5, 0, 11,
    }))
    fmt.Printf("\n%.5f\n", cholesky(4, []float64{
        18, 22, 54, 42,
        22, 70, 86, 62,
        54, 86, 174, 134,
        42, 62, 134, 106,
    }))
}
