package main

import (
    "fmt"
    "math/cmplx"
)

type matrix struct {
    stride int
    ele    []complex128
}

func like(a *matrix) *matrix {
    return &matrix{a.stride, make([]complex128, len(a.ele))}
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
    demo("A:", &matrix{3, []complex128{
        25, 15, -5,
        15, 18, 0,
        -5, 0, 11,
    }})
    demo("A:", &matrix{4, []complex128{
        18, 22, 54, 42,
        22, 70, 86, 62,
        54, 86, 174, 134,
        42, 62, 134, 106,
    }})
    // one more example, from the Numpy manual, with a non-real
    demo("A:", &matrix{2, []complex128{
        1, -2i,
        2i, 5,
    }})
}

func demo(heading string, a *matrix) {
    a.print(heading)
    a.choleskyDecomp().print("Cholesky factor L:")
}
