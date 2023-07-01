package main

import (
    "fmt"
    "strings"
)

type uintMatrix [][]uint

func (m uintMatrix) String() string {
    var max uint
    for _, r := range m {
        for _, e := range r {
            if e > max {
                max = e
            }
        }
    }
    w := len(fmt.Sprint(max))
    b := &strings.Builder{}
    for _, r := range m {
        fmt.Fprintf(b, "|%*d", w, r[0])
        for _, e := range r[1:] {
            fmt.Fprintf(b, " %*d", w, e)
        }
        fmt.Fprintln(b, "|")
    }
    return b.String()
}

func kronecker(m1, m2 uintMatrix) uintMatrix {
    p := make(uintMatrix, len(m1)*len(m2))
    for r1i, r1 := range m1 {
        for r2i, r2 := range m2 {
            rp := make([]uint, len(r1)*len(r2))
            for c1i, e1 := range r1 {
                for c2i, e2 := range r2 {
                    rp[c1i*len(r2)+c2i] = e1 * e2
                }
            }
            p[r1i*len(m2)+r2i] = rp
        }
    }
    return p
}

func sample(m1, m2 uintMatrix) {
    fmt.Println("m1:")
    fmt.Print(m1)
    fmt.Println("m2:")
    fmt.Print(m2)
    fmt.Println("m1 ⊗ m2:")
    fmt.Print(kronecker(m1, m2))
}

func main() {
    sample(uintMatrix{
        {1, 2},
        {3, 4},
    }, uintMatrix{
        {0, 5},
        {6, 7},
    })
    sample(uintMatrix{
        {0, 1, 0},
        {1, 1, 1},
        {0, 1, 0},
    }, uintMatrix{
        {1, 1, 1, 1},
        {1, 0, 0, 1},
        {1, 1, 1, 1},
    })
}
