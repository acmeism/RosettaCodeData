package main

import (
    "fmt"

    "github.com/skelterjohn/go.matrix"
)

func main() {
    fmt.Println(matrix.MakeDenseMatrixStacked([][]float64{
        {1, 2},
        {3, 4}}).Det())
    fmt.Println(matrix.MakeDenseMatrixStacked([][]float64{
        {2, 9, 4},
        {7, 5, 3},
        {6, 1, 8}}).Det())
}
