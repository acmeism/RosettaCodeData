package main

import "fmt"

type vector = []float64
type matrix []vector

func (m1 matrix) mul(m2 matrix) matrix {
    rows1, cols1 := len(m1), len(m1[0])
    rows2, cols2 := len(m2), len(m2[0])
    if cols1 != rows2 {
        panic("Matrices cannot be multiplied.")
    }
    result := make(matrix, rows1)
    for i := 0; i < rows1; i++ {
        result[i] = make(vector, cols2)
        for j := 0; j < cols2; j++ {
            for k := 0; k < rows2; k++ {
                result[i][j] += m1[i][k] * m2[k][j]
            }
        }
    }
    return result
}

func identityMatrix(n int) matrix {
    if n < 1 {
        panic("Size of identity matrix can't be less than 1")
    }
    ident := make(matrix, n)
    for i := 0; i < n; i++ {
        ident[i] = make(vector, n)
        ident[i][i] = 1
    }
    return ident
}

func (m matrix) pow(n int) matrix {
    le := len(m)
    if le != len(m[0]) {
        panic("Not a square matrix")
    }
    switch {
    case n < 0:
        panic("Negative exponents not supported")
    case n == 0:
        return identityMatrix(le)
    case n == 1:
        return m
    }
    pow := identityMatrix(le)
    base := m
    e := n
    for e > 0 {
        if (e & 1) == 1 {
            pow = pow.mul(base)
        }
        e >>= 1
        base = base.mul(base)
    }
    return pow
}

func main() {
    m := matrix{{3, 2}, {2, 1}}
    for i := 0; i <= 10; i++ {
        fmt.Println("** Power of", i, "**")
        fmt.Println(m.pow(i))
        fmt.Println()
    }
}
