package main

import (
    "fmt"
    "math"
)

func main() {
    list := []float64{1, 8, 2, -3, 0, 1, 1, -2.3, 0, 5.5, 8, 6, 2, 9, 11, 10, 3}
    maxDiff := -1.0
    var maxPairs [][2]float64
    for i := 1; i < len(list); i++ {
        diff := math.Abs(list[i-1] - list[i])
        if diff > maxDiff {
            maxDiff = diff
            maxPairs = [][2]float64{{list[i-1], list[i]}}
        } else if diff == maxDiff {
            maxPairs = append(maxPairs, [2]float64{list[i-1], list[i]})
        }
    }
    fmt.Println("The maximum difference between adjacent pairs of the list is:", maxDiff)
    fmt.Println("The pairs with this difference are:", maxPairs)
}
