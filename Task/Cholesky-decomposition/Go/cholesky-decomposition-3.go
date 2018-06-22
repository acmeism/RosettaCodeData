package main

import (
    "fmt"

    "gonum.org/v1/gonum/mat"
)

func cholesky(order int, elements []float64) fmt.Formatter {
    var c mat.Cholesky
    c.Factorize(mat.NewSymDense(order, elements))
    return mat.Formatted(c.LTo(nil))
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
