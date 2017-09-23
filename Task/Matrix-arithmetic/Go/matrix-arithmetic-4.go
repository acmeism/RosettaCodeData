package main

import (
    "fmt"

    "github.com/gonum/matrix/mat64"
)

func main() {
    fmt.Println(mat64.Det(mat64.NewDense(2, 2, []float64{
        1, 2,
        3, 4})))
    fmt.Println(mat64.Det(mat64.NewDense(3, 3, []float64{
        2, 9, 4,
        7, 5, 3,
        6, 1, 8})))
}
