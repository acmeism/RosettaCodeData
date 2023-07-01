package main

import (
    "fmt"
    "log"
)

func main() {
    m := [][]int{
        {1, 3, 7, 8, 10},
        {2, 4, 16, 14, 4},
        {3, 1, 9, 18, 11},
        {12, 14, 17, 18, 20},
        {7, 1, 3, 9, 5},
    }
    if len(m) != len(m[0]) {
        log.Fatal("Matrix must be square.")
    }
    sum := 0
    for i := 1; i < len(m); i++ {
        for j := 0; j < i; j++ {
            sum = sum + m[i][j]
        }
    }
    fmt.Println("Sum of elements below main diagonal is", sum)
}
