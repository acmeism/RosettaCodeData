package main

import (
    "fmt"

    "gonum.org/v1/gonum/mat"
)

var m = mat.NewDense(4, 4, []float64{
    2, -1, 5, 1,
    3, 2, 2, -6,
    1, 3, 3, -1,
    5, -2, -3, 3,
})

var v = []float64{-3, -32, -47, 49}

func main() {
    x := make([]float64, len(v))
    b := make([]float64, len(v))
    d := mat.Det(m)
    for c := range v {
        mat.Col(b, c, m)
        m.SetCol(c, v)
        x[c] = mat.Det(m) / d
        m.SetCol(c, b)
    }
    fmt.Println(x)
}
