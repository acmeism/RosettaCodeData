package main

import "fmt"

type matrix []float64

func main() {
    n := 3
    m := I(n)
    // dump flat represenation
    fmt.Println(m)

    // function x turns a row and column into an index into the
    // flat representation.
    x := func(r, c int) int { return r*n + c }

    // access m by row and column.
    for r := 0; r < n; r++ {
        for c := 0; c < n; c++ {
            fmt.Print(m[x(r, c)], " ")
        }
        fmt.Println()
    }
}

func I(n int) matrix {
    m := make(matrix, n*n)
    // a fast way to initialize the flat representation
    n++
    for i := 0; i < len(m); i += n {
        m[i] = 1
    }
    return m
}
