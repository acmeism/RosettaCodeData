package main

import (
    "fmt"
    "singlep"
)

func main() {
    // dot selector syntax references package variables and functions
    singlep.X = 2
    singlep.Y = 3
    fmt.Println(singlep.X, singlep.Y)
    fmt.Println(singlep.F())
}
