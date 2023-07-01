package main

import (
    "fmt"

    "github.com/skelterjohn/go.matrix"
)

var m = matrix.MakeDenseMatrixStacked([][]float64{
    {2, -1, 5, 1},
    {3, 2, 2, -6},
    {1, 3, 3, -1},
    {5, -2, -3, 3},
})

var v = []float64{-3, -32, -47, 49}

func main() {
    x := make([]float64, len(v))
    b := make([]float64, len(v))
    d := m.Det()
    for c := range v {
        m.BufferCol(c, b)
        m.FillCol(c, v)
        x[c] = m.Det() / d
        m.FillCol(c, b)
    }
    fmt.Println(x)
}
