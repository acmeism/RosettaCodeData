package main

import (
    "fmt"
    "math"
)

func uniq(list []float64) []float64 {
    unique_set := map[float64]int{}
    i := 0
    nan := false
    for _, x := range list {
        if _, exists := unique_set[x]; exists {
            continue
        }
        if math.IsNaN(x) {
            if nan {
                continue
            } else {
                nan = true
            }
        }
        unique_set[x] = i
        i++
    }
    result := make([]float64, len(unique_set))
    for x, i := range unique_set {
        result[i] = x
    }
    return result
}

func main() {
    fmt.Println(uniq([]float64{1, 2, math.NaN(), 2, math.NaN(), 4}))
}
