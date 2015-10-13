package main

import (
    "fmt"

    "github.com/gonum/matrix/mat64"
)

func main() {
    a := mat64.NewDense(2, 4, []float64{
        1, 2, 3, 4,
        5, 6, 7, 8,
    })
    b := mat64.NewDense(4, 3, []float64{
        1, 2, 3,
        4, 5, 6,
        7, 8, 9,
        10, 11, 12,
    })
    var m mat64.Dense
    m.Mul(a, b)
    fmt.Println(mat64.Formatted(&m))
}
