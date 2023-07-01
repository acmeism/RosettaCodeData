package main

import (
    "fmt"

    "github.com/skelterjohn/go.matrix"
)

func main() {
    fmt.Println(matrix.Kronecker(
        matrix.MakeDenseMatrixStacked([][]float64{
            {1, 2},
            {3, 4},
        }),
        matrix.MakeDenseMatrixStacked([][]float64{
            {0, 5},
            {6, 7},
        })))
    fmt.Println()
    fmt.Println(matrix.Kronecker(
        matrix.MakeDenseMatrixStacked([][]float64{
            {0, 1, 0},
            {1, 1, 1},
            {0, 1, 0},
        }),
        matrix.MakeDenseMatrixStacked([][]float64{
            {1, 1, 1, 1},
            {1, 0, 0, 1},
            {1, 1, 1, 1},
        })))
}
