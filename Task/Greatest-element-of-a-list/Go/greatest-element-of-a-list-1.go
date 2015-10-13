package main

import (
    "fmt"

    "github.com/gonum/floats"
)

func main() {
    fmt.Println(floats.Max([]float64{3, 1, 4, 1}))
}
