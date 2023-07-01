package main

import (
    "fmt"

    mat "github.com/skelterjohn/go.matrix"
)

func main() {
    demo(mat.MakeDenseMatrix([]float64{
        25, 15, -5,
        15, 18, 0,
        -5, 0, 11,
    }, 3, 3))
    demo(mat.MakeDenseMatrix([]float64{
        18, 22, 54, 42,
        22, 70, 86, 62,
        54, 86, 174, 134,
        42, 62, 134, 106,
    }, 4, 4))
}

func demo(m *mat.DenseMatrix) {
    fmt.Println("A:")
    fmt.Println(m)
    l, err := m.Cholesky()
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Println("L:")
    fmt.Println(l)
}
