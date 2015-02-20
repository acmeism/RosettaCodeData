package main

import (
    "fmt"
    "math"
    "math/cmplx"
)

// a type to represent matrices
type matrix struct {
    ele  []complex128
    cols int
}

// conjugate transpose, implemented here as a method on the matrix type.
func (m *matrix) conjTranspose() *matrix {
    r := &matrix{make([]complex128, len(m.ele)), len(m.ele) / m.cols}
    rx := 0
    for _, e := range m.ele {
        r.ele[rx] = cmplx.Conj(e)
        rx += r.cols
        if rx >= len(r.ele) {
            rx -= len(r.ele) - 1
        }
    }
    return r
}

// program to demonstrate capabilites on example matricies
func main() {
    show("h", matrixFromRows([][]complex128{
        {3, 2 + 1i},
        {2 - 1i, 1}}))

    show("n", matrixFromRows([][]complex128{
        {1, 1, 0},
        {0, 1, 1},
        {1, 0, 1}}))

    show("u", matrixFromRows([][]complex128{
        {math.Sqrt2 / 2, math.Sqrt2 / 2, 0},
        {math.Sqrt2 / -2i, math.Sqrt2 / 2i, 0},
        {0, 0, 1i}}))
}

func show(name string, m *matrix) {
    m.print(name)
    ct := m.conjTranspose()
    ct.print(name + "_ct")

    fmt.Println("Hermitian:", m.equal(ct, 1e-14))

    mct := m.mult(ct)
    ctm := ct.mult(m)
    fmt.Println("Normal:", mct.equal(ctm, 1e-14))

    i := eye(m.cols)
    fmt.Println("Unitary:", mct.equal(i, 1e-14) && ctm.equal(i, 1e-14))
}

// two constructors
func matrixFromRows(rows [][]complex128) *matrix {
    m := &matrix{make([]complex128, len(rows)*len(rows[0])), len(rows[0])}
    for rx, row := range rows {
        copy(m.ele[rx*m.cols:(rx+1)*m.cols], row)
    }
    return m
}

func eye(n int) *matrix {
    r := &matrix{make([]complex128, n*n), n}
    n++
    for x := 0; x < len(r.ele); x += n {
        r.ele[x] = 1
    }
    return r
}

// print method outputs matrix to stdout
func (m *matrix) print(heading string) {
    fmt.Print("\n", heading, "\n")
    for e := 0; e < len(m.ele); e += m.cols {
        fmt.Printf("%6.3f ", m.ele[e:e+m.cols])
        fmt.Println()
    }
}

// equal method uses ε to allow for floating point error.
func (a *matrix) equal(b *matrix, ε float64) bool {
    for x, aEle := range a.ele {
        if math.Abs(real(aEle)-real(b.ele[x])) > math.Abs(real(aEle))*ε ||
            math.Abs(imag(aEle)-imag(b.ele[x])) > math.Abs(imag(aEle))*ε {
            return false
        }
    }
    return true
}

// mult method taken from matrix multiply task
func (m1 *matrix) mult(m2 *matrix) (m3 *matrix) {
    m3 = &matrix{make([]complex128, (len(m1.ele)/m1.cols)*m2.cols), m2.cols}
    for m1c0, m3x := 0, 0; m1c0 < len(m1.ele); m1c0 += m1.cols {
        for m2r0 := 0; m2r0 < m2.cols; m2r0++ {
            for m1x, m2x := m1c0, m2r0; m2x < len(m2.ele); m2x += m2.cols {
                m3.ele[m3x] += m1.ele[m1x] * m2.ele[m2x]
                m1x++
            }
            m3x++
        }
    }
    return m3
}
