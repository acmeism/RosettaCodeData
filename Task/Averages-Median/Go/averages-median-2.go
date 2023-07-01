package main

import "fmt"

func main() {
    fmt.Println(median([]float64{3, 1, 4, 1}))    // prints 2
    fmt.Println(median([]float64{3, 1, 4, 1, 5})) // prints 3
}

func median(a []float64) float64 {
    half := len(a) / 2
    med := sel(a, half)
    if len(a)%2 == 0 {
        return (med + a[half-1]) / 2
    }
    return med
}

func sel(list []float64, k int) float64 {
    for i, minValue := range list[:k+1] {
        minIndex := i
        for j := i + 1; j < len(list); j++ {
            if list[j] < minValue {
                minIndex = j
                minValue = list[j]
                list[i], list[minIndex] = minValue, list[i]
            }
        }
    }
    return list[k]
}
