package main

import (
    "fmt"
    "math"
)

func factorial(n float64) float64 {
    return math.Gamma(n + 1)
}

func main() {
    for i := 0.; i <= 10; i++ {
        fmt.Println(i, factorial(i))
    }
    fmt.Println(100, factorial(100))
}
