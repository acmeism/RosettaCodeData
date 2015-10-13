package main

import (
    "fmt"

    "github.com/gonum/matrix/mat64"
)

func main() {
    m := mat64.NewDense(2, 3, []float64{
        1, 2, 3,
        4, 5, 6,
    })
    fmt.Println(mat64.Formatted(m))
    fmt.Println()
    fmt.Println(mat64.Formatted(m.T()))
}
