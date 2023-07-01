package main

import "fmt"

func main() {
    fmt.Println(I(3))
}

func I(n int) [][]float64 {
    m := make([][]float64, n)
    for i := 0; i < n; i++ {
        a := make([]float64, n)
        a[i] = 1
        m[i] = a
    }
    return m
}
