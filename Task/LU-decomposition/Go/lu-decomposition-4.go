package main

import (
    "fmt"

    mat "github.com/skelterjohn/go.matrix"
)

func main() {
    showLU(mat.MakeDenseMatrixStacked([][]float64{
        {1, 3, 5},
        {2, 4, 7},
        {1, 1, 0}}))
    showLU(mat.MakeDenseMatrixStacked([][]float64{
        {11, 9, 24, 2},
        {1, 5, 2, 6},
        {3, 17, 18, 1},
        {2, 5, 7, 1}}))
}

func showLU(a *mat.DenseMatrix) {
    fmt.Printf("\na:\n%v\n", a)
    l, u, p := a.LU()
    fmt.Printf("l:\n%v\n", l)
    fmt.Printf("u:\n%v\n", u)
    fmt.Printf("p:\n%v\n", p)
}
