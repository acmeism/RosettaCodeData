package main

import (
    "fmt"

    "github.com/gonum/floats"
)

func main() {
	fmt.Println(floats.Max([]float64{63, 70, 37, 34, 83, 27, 19, 97, 9, 17})) // prt 97
	fmt.Println(floats.Min([]float64{63, 70, 37, 34, 83, 27, 19, 97, 9, 17})) // prt 9
}
