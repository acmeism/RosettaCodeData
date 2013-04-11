package main

import "fmt"

type matrix []float64

func main() {
    fmt.Println(I(3))
}

func I(n int) matrix {
    m := make(matrix, n*n)
    n++
    for i := 0; i < len(m); i += n {
        m[i] = 1
    }
    return m
}
