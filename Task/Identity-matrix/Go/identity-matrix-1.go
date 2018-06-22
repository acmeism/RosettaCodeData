package main

import (
    "fmt"

    "gonum.org/v1/gonum/mat"
)

func eye(n int) *mat.Dense {
    m := mat.NewDense(n, n, nil)
    for i := 0; i < n; i++ {
        m.Set(i, i, 1)
    }
    return m
}

func main() {
    fmt.Println(mat.Formatted(eye(3)))
}
