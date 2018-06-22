package main

import (
    "fmt"

    "gonum.org/v1/gonum/mat"
)

func main() {
    a := mat.NewDense(2, 4, []float64{
        1, 2, 3, 4,
        5, 6, 7, 8,
    })
    b := mat.NewDense(4, 3, []float64{
        1, 2, 3,
        4, 5, 6,
        7, 8, 9,
        10, 11, 12,
    })
    var m mat.Dense
    m.Mul(a, b)
    fmt.Println(mat.Formatted(&m))
}
