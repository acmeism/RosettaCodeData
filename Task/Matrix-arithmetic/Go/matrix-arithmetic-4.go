package main

import (
    "fmt"

    "gonum.org/v1/gonum/mat"
)

func main() {
    fmt.Println(mat.Det(mat.NewDense(2, 2, []float64{
        1, 2,
        3, 4})))
    fmt.Println(mat.Det(mat.NewDense(3, 3, []float64{
        2, 9, 4,
        7, 5, 3,
        6, 1, 8})))
}
