package main

import (
    "fmt"
    "math/big"
)

func gcd(x, y int64) int64 {
    return new(big.Int).GCD(nil, nil, big.NewInt(x), big.NewInt(y)).Int64()
}

func main() {
    fmt.Println(gcd(33, 77))
    fmt.Println(gcd(49865, 69811))
}
