package main

import (
    "fmt"

    "github.com/gonum/matrix/mat64"
)

func eye(n int) *mat64.Dense {
    m := mat64.NewDense(n, n, nil)
    for i := 0; i < n; i++ {
        m.Set(i, i, 1)
    }
    return m
}

func main() {
    fmt.Println(mat64.Formatted(eye(3)))
}
