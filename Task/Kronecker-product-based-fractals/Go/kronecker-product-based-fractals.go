package main

import "fmt"

type matrix [][]int

func (m1 matrix) kroneckerProduct(m2 matrix) matrix {
    m := len(m1)
    n := len(m1[0])
    p := len(m2)
    q := len(m2[0])
    rtn := m * p
    ctn := n * q
    r := make(matrix, rtn)
    for i := range r {
        r[i] = make([]int, ctn) // all elements zero by default
    }
    for i := 0; i < m; i++ {
        for j := 0; j < n; j++ {
            for k := 0; k < p; k++ {
                for l := 0; l < q; l++ {
                    r[p*i+k][q*j+l] = m1[i][j] * m2[k][l]
                }
            }
        }
    }
    return r
}

func (m matrix) kroneckerPower(n int) matrix {
    pow := m
    for i := 1; i < n; i++ {
        pow = pow.kroneckerProduct(m)
    }
    return pow
}

func (m matrix) print(text string) {
    fmt.Println(text, "fractal :\n")
    for i := range m {
        for j := range m[0] {
            if m[i][j] == 1 {
                fmt.Print("*")
            } else {
                fmt.Print(" ")
            }
        }
        fmt.Println()
    }
    fmt.Println()
}

func main() {
    m1 := matrix{{0, 1, 0}, {1, 1, 1}, {0, 1, 0}}
    m1.kroneckerPower(4).print("Vivsek")

    m2 := matrix{{1, 1, 1}, {1, 0, 1}, {1, 1, 1}}
    m2.kroneckerPower(4).print("Sierpinski carpet")
}
