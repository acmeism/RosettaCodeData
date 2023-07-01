package main

import (
    "fmt"

    "gonum.org/v1/gonum/mat"
)

func main() {
    m := mat.NewDense(2, 3, []float64{
        1, 2, 3,
        4, 5, 6,
    })
    fmt.Println(mat.Formatted(m))
    fmt.Println()
    fmt.Println(mat.Formatted(m.T()))
}
