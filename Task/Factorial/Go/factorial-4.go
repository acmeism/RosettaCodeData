package main

import (
    "fmt"
    "math"
    "math/big"
)

func lfactorial(n float64) float64 {
    l, _ := math.Lgamma(n + 1)
    return l
}

func factorial(n float64) *big.Float {
    i, frac := math.Modf(lfactorial(n) * math.Log2E)
    z := big.NewFloat(math.Exp2(frac))
    return z.SetMantExp(z, int(i))
}

func main() {
    for i := 0.; i <= 10; i++ {
        fmt.Println(i, factorial(i))
    }
    fmt.Println(100, factorial(100))
    fmt.Println(800, factorial(800))
}
