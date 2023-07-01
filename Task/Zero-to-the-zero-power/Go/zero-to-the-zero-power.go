package main

import (
    "fmt"
    "math"
    "math/big"
    "math/cmplx"
)

func main() {
    fmt.Println("float64:    ", math.Pow(0, 0))
    var b big.Int
    fmt.Println("big integer:", b.Exp(&b, &b, nil))
    fmt.Println("complex:    ", cmplx.Pow(0, 0))
}
