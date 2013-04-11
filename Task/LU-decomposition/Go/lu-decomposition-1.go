package main

import "fmt"

type matrix [][]float64

func zero(n int) matrix {
    r := make([][]float64, n)
    a := make([]float64, n*n)
    for i := range r {
        r[i] = a[n*i : n*(i+1)]
    }
    return r
}

func eye(n int) matrix {
    r := zero(n)
    for i := range r {
        r[i][i] = 1
    }
    return r
}

func (m matrix) print(label string) {
    if label > "" {
        fmt.Printf("%s:\n", label)
    }
    for _, r := range m {
        for _, e := range r {
            fmt.Printf(" %9.5f", e)
        }
        fmt.Println()
    }
}

func (a matrix) pivotize() matrix {
    p := eye(len(a))
    for j, r := range a {
        max := r[j]
        row := j
        for i := j; i < len(a); i++ {
            if a[i][j] > max {
                max = a[i][j]
                row = i
            }
        }
        if j != row {
            // swap rows
            p[j], p[row] = p[row], p[j]
        }
    }
    return p
}

func (m1 matrix) mul(m2 matrix) matrix {
    r := zero(len(m1))
    for i, r1 := range m1 {
        for j := range m2 {
            for k := range m1 {
                r[i][j] += r1[k] * m2[k][j]
            }
        }
    }
    return r
}

func (a matrix) lu() (l, u, p matrix) {
    l = zero(len(a))
    u = zero(len(a))
    p = a.pivotize()
    a = p.mul(a)
    for j := range a {
        l[j][j] = 1
        for i := 0; i <= j; i++ {
            sum := 0.
            for k := 0; k < i; k++ {
                sum += u[k][j] * l[i][k]
            }
            u[i][j] = a[i][j] - sum
        }
        for i := j; i < len(a); i++ {
            sum := 0.
            for k := 0; k < j; k++ {
                sum += u[k][j] * l[i][k]
            }
            l[i][j] = (a[i][j] - sum) / u[j][j]
        }
    }
    return
}

func main() {
    showLU(matrix{
        {1, 3, 5},
        {2, 4, 7},
        {1, 1, 0}})
    showLU(matrix{
        {11, 9, 24, 2},
        {1, 5, 2, 6},
        {3, 17, 18, 1},
        {2, 5, 7, 1}})
}

func showLU(a matrix) {
    a.print("\na")
    l, u, p := a.lu()
    l.print("l")
    u.print("u")
    p.print("p")
}
