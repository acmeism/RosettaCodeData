package main

import (
    "math/big"
    "fmt"
)

func factorial(n int64) *big.Int {
    var z big.Int
    return z.MulRange(1, n)
}

func main() {
    fmt.Println(factorial(800))
}
