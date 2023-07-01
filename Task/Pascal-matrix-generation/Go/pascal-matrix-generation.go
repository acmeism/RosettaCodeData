package main

import (
    "fmt"
    "strings"
)

func binomial(n, k int) int {
    if n < k {
        return 0
    }
    if n == 0 || k == 0 {
        return 1
    }
    num := 1
    for i := k + 1; i <= n; i++ {
        num *= i
    }
    den := 1
    for i := 2; i <= n-k; i++ {
        den *= i
    }
    return num / den
}

func pascalUpperTriangular(n int) [][]int {
    m := make([][]int, n)
    for i := 0; i < n; i++ {
        m[i] = make([]int, n)
        for j := 0; j < n; j++ {
            m[i][j] = binomial(j, i)
        }
    }
    return m
}

func pascalLowerTriangular(n int) [][]int {
    m := make([][]int, n)
    for i := 0; i < n; i++ {
        m[i] = make([]int, n)
        for j := 0; j < n; j++ {
            m[i][j] = binomial(i, j)
        }
    }
    return m
}

func pascalSymmetric(n int) [][]int {
    m := make([][]int, n)
    for i := 0; i < n; i++ {
        m[i] = make([]int, n)
        for j := 0; j < n; j++ {
            m[i][j] = binomial(i+j, i)
        }
    }
    return m
}

func printMatrix(title string, m [][]int) {
    n := len(m)
    fmt.Println(title)
    fmt.Print("[")
    for i := 0; i < n; i++ {
        if i > 0 {
            fmt.Print(" ")
        }
        mi := strings.Replace(fmt.Sprint(m[i]), " ", ", ", -1)
        fmt.Print(mi)
        if i < n-1 {
            fmt.Println(",")
        } else {
            fmt.Println("]\n")
        }
    }
}

func main() {
    printMatrix("Pascal upper-triangular matrix", pascalUpperTriangular(5))
    printMatrix("Pascal lower-triangular matrix", pascalLowerTriangular(5))
    printMatrix("Pascal symmetric matrix", pascalSymmetric(5))
}
