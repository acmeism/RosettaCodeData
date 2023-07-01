package main

import (
    "fmt"
    "math/big"
)

func main() {
    fmt.Println(factorial(800))
}

func factorial(n int64) *big.Int {
    if n < 0 {
        return nil
    }
    r := big.NewInt(1)
    var f big.Int
    for i := int64(2); i <= n; i++ {
        r.Mul(r, f.SetInt64(i))
    }
    return r
}
