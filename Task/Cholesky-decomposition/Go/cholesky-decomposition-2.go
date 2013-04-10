package main

import (
    "fmt"
    "math/cmplx"
)

type matrix struct {
    ele    []complex128
    stride int
}

func matrixFromRows(rows [][]complex128) *matrix {
    if len(rows) == 0 {
        return &matrix{nil, 0}
    }
    m := &matrix{make([]complex128, len(rows)*len(rows[0])), len(rows[0])}
    for rx, row := range rows {
        copy(m.ele[rx*m.stride:(rx+1)*m.stride], row)
    }
    return m
}

func like(a *matrix) *matrix {
    return &matrix{make([]complex128, len(a.ele)), a.stride}
}

func (m *matrix) print(heading string) {
    if heading > "" {
        fmt.Print("\n", heading, "\n")
    }
    for e := 0; e < len(m.ele); e += m.stride {
        fmt.Printf("%7.2f ", m.ele[e:e+m.stride])
        fmt.Println()
    }
}

func (a *matrix) choleskyDecomp() *matrix {
    l := like(a)
    // Cholesky-Banachiewicz algorithm
    for r, rxc0 := 0, 0; r < a.stride; r++ {
        // calculate elements along row, up to diagonal
        x := rxc0
        for c, cxc0 := 0, 0; c < r; c++ {
            sum := a.ele[x]
            for k := 0; k < c; k++ {
                sum -= l.ele[rxc0+k] * cmplx.Conj(l.ele[cxc0+k])
            }
            l.ele[x] = sum / l.ele[cxc0+c]
            x++
            cxc0 += a.stride
        }
        // calcualate diagonal element
        sum := a.ele[x]
        for k := 0; k < r; k++ {
            sum -= l.ele[rxc0+k] * cmplx.Conj(l.ele[rxc0+k])
        }
        l.ele[x] = cmplx.Sqrt(sum)
        rxc0 += a.stride
    }
    return l
}

func main() {
    demo("A:", matrixFromRows([][]complex128{
        {25, 15, -5},
        {15, 18, 0},
        {-5, 0, 11},
    }))
    demo("A:", matrixFromRows([][]complex128{
        {18, 22, 54, 42},
        {22, 70, 86, 62},
        {54, 86, 174, 134},
        {42, 62, 134, 106},
    }))
}

func demo(heading string, a *matrix) {
    a.print(heading)
    a.choleskyDecomp().print("Cholesky factor L:")
}
