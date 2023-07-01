package main

import (
    "fmt"
    "math"
)

type vector = []float64
type matrix []vector

func (m matrix) print(title string) {
    fmt.Println(title)
    for _, v := range m {
        fmt.Printf("% f\n", v)
    }
}

func I(n int) matrix {
    b := make(matrix, n)
    for i := 0; i < n; i++ {
        b[i] = make(vector, n)
        b[i][i] = 1
    }
    return b
}

func (m matrix) inverse() matrix {
    n := len(m)
    for _, v := range m {
        if n != len(v) {
            panic("Not a square matrix")
        }
    }
    b := I(n)
    a := make(matrix, n)
    for i, v := range m {
        a[i] = make(vector, n)
        copy(a[i], v)
   }
   for k := range a {
       iMax := 0
       max := -1.
       for i := k; i < n; i++ {
           row := a[i]
           // compute scale factor s = max abs in row
           s := -1.
           for j := k; j < n; j++ {
               x := math.Abs(row[j])
               if x > s {
                   s = x
               }
           }
           if s == 0 {
               panic("Irregular matrix")
           }
           // scale the abs used to pick the pivot.
           if abs := math.Abs(row[k]) / s; abs > max {
               iMax = i
               max = abs
           }
       }
       if k != iMax {
           a[k], a[iMax] = a[iMax], a[k]
           b[k], b[iMax] = b[iMax], b[k]
       }
       akk := a[k][k]
       for j := 0; j < n; j++ {
           a[k][j] /= akk
           b[k][j] /= akk
       }
       for i := 0; i < n; i++ {
           if (i != k) {
               aik := a[i][k]
               for j := 0; j < n; j++ {
                   a[i][j] -= a[k][j] * aik
                   b[i][j] -= b[k][j] * aik
               }
           }
       }
    }
    return b
}

func main() {
    a := matrix{{1, 2, 3}, {4, 1, 6}, {7, 8, 9}}
    a.inverse().print("Inverse of A is:\n")

    b := matrix{{2, -1, 0}, {-1, 2, -1}, {0, -1, 2}}
    b.inverse().print("Inverse of B is:\n")
}
