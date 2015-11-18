package main

import (
    "fmt"

    "github.com/gonum/floats"
)

var a = []float64{1, 2, 5}

func main() {
    fmt.Println("Sum:    ", floats.Sum(a))
    fmt.Println("Product:", floats.Prod(a))
}
