package main

import (
    "fmt"
    "math/big"
)

func bellTriangle(n int) [][]*big.Int {
    tri := make([][]*big.Int, n)
    for i := 0; i < n; i++ {
        tri[i] = make([]*big.Int, i)
        for j := 0; j < i; j++ {
            tri[i][j] = new(big.Int)
        }
    }
    tri[1][0].SetUint64(1)
    for i := 2; i < n; i++ {
        tri[i][0].Set(tri[i-1][i-2])
        for j := 1; j < i; j++ {
            tri[i][j].Add(tri[i][j-1], tri[i-1][j-1])
        }
    }
    return tri
}

func main() {
    bt := bellTriangle(51)
    fmt.Println("First fifteen and fiftieth Bell numbers:")
    for i := 1; i <= 15; i++ {
        fmt.Printf("%2d: %d\n", i, bt[i][0])
    }
    fmt.Println("50:", bt[50][0])
    fmt.Println("\nThe first ten rows of Bell's triangle:")
    for i := 1; i <= 10; i++ {
        fmt.Println(bt[i])
    }
}
