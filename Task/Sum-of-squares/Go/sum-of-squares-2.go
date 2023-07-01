package main

import (
    "fmt"

    "github.com/gonum/floats"
)

var v = []float64{1, 2, .5}

func main() {
    fmt.Println(floats.Dot(v, v))
}
