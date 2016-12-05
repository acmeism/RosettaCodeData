package main

import (
    "fmt"
    "math"
)

func f(t float64) float64 {
    return math.Sqrt(math.Abs(t)) + 5*math.Pow(t, 3)
}

func main() {
    var a [11]float64
    for i := range a {
        fmt.Scan(&a[i])
    }
    for i := len(a) - 1; i >= 0; i-- {
        if y := f(a[i]); y > 400 {
            fmt.Println(i, "TOO LARGE")
        } else {
            fmt.Println(i, y)
        }
    }
}
