package main

import (
    "fmt"

    mat "github.com/skelterjohn/go.matrix"
)

func main() {
    m := mat.MakeDenseMatrixStacked([][]float64{
        {1, 2, 3},
        {4, 5, 6},
    })
    fmt.Println("original:")
    fmt.Println(m)
    m = m.Transpose()
    fmt.Println("transpose:")
    fmt.Println(m)
}
