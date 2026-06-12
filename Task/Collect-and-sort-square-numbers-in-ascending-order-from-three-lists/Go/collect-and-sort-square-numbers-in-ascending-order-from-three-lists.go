package main

import (
    "fmt"
    "math"
    "sort"
)

func isSquare(n int) bool {
    s := int(math.Sqrt(float64(n)))
    return s*s == n
}

func main() {
    lists := [][]int{
        {3, 4, 34, 25, 9, 12, 36, 56, 36},
        {2, 8, 81, 169, 34, 55, 76, 49, 7},
        {75, 121, 75, 144, 35, 16, 46, 35},
    }
    var squares []int
    for _, list := range lists {
        for _, e := range list {
            if isSquare(e) {
                squares = append(squares, e)
            }
        }
    }
    sort.Ints(squares)
    fmt.Println(squares)
}
