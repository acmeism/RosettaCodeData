package main

import (
    "fmt"
    "sort"
)

func firstMissingPositive(a []int) int {
    var b []int
    for _, e := range a {
        if e > 0 {
            b = append(b, e)
        }
    }
    sort.Ints(b)
    le := len(b)
    if le == 0 || b[0] > 1 {
        return 1
    }
    for i := 1; i < le; i++ {
        if b[i]-b[i-1] > 1 {
            return b[i-1] + 1
        }
    }
    return b[le-1] + 1
}

func main() {
    fmt.Println("The first missing positive integers for the following arrays are:\n")
    aa := [][]int{
        {1, 2, 0}, {3, 4, -1, 1}, {7, 8, 9, 11, 12}, {1, 2, 3, 4, 5},
        {-6, -5, -2, -1}, {5, -5}, {-2}, {1}, {}}
    for _, a := range aa {
        fmt.Println(a, "->", firstMissingPositive(a))
    }
}
