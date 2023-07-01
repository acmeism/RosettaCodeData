package main

import (
    "fmt"
    "singlep"
)

func main() {
    // dot selector syntax references package variables and functions
    fmt.Println(singlep.X, singlep.Y)
    fmt.Println(singlep.F())
}
