package main

import (
    "fmt"

    mat "github.com/skelterjohn/go.matrix"
)

func main() {
    a := mat.MakeDenseMatrixStacked([][]float64{
        {1, 2, 3, 4},
        {5, 6, 7, 8},
    })
    b := mat.MakeDenseMatrixStacked([][]float64{
        {1, 2, 3},
        {4, 5, 6},
        {7, 8, 9},
        {10, 11, 12},
    })
    fmt.Printf("Matrix A:\n%v\n", a)
    fmt.Printf("Matrix B:\n%v\n", b)
    p, err := a.TimesDense(b)
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Printf("Product of A and B:\n%v\n", p)
}
