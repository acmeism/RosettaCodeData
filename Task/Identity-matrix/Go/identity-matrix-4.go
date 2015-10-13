package main

import "fmt"

func main() {
    fmt.Println(I(3))
}

func I(n int) [][]float64 {
    m := make([][]float64, n)
    a := make([]float64, n*n)
    for i := 0; i < n; i++ {
        a[i] = 1
        m[i] = a[:n]
        a = a[n:]
    }
    return m
}
