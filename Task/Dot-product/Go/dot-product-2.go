package main

import (
    "fmt"

    "github.com/gonum/floats"
)

var (
    v1 = []float64{1, 3, -5}
    v2 = []float64{4, -2, -1}
)

func main() {
    fmt.Println(floats.Dot(v1, v2))
}
