package main

import (
    "fmt"
    "math"
)

// symmetric and lower use a packed representation that stores only
// the lower triangle.

type symmetric struct {
    order int
    ele   []float64
}

type lower struct {
    order int
    ele   []float64
}

// symmetric.print prints a square matrix from the packed representation,
// printing the upper triange as a transpose of the lower.
func (s *symmetric) print() {
    const eleFmt = "%10.5f "
    row, diag := 1, 0
    for i, e := range s.ele {
        fmt.Printf(eleFmt, e)
        if i == diag {
            for j, col := diag+row, row; col < s.order; j += col {
                fmt.Printf(eleFmt, s.ele[j])
                col++
            }
            fmt.Println()
            row++
            diag += row
        }
    }
}

// lower.print prints a square matrix from the packed representation,
// printing the upper triangle as all zeros.
func (l *lower) print() {
    const eleFmt = "%10.5f "
    row, diag := 1, 0
    for i, e := range l.ele {
        fmt.Printf(eleFmt, e)
        if i == diag {
            for j := row; j < l.order; j++ {
                fmt.Printf(eleFmt, 0.)
            }
            fmt.Println()
            row++
            diag += row
        }
    }
}

// choleskyLower returns the cholesky decomposition of a symmetric real
// matrix.  The matrix must be positive definite but this is not checked.
func (a *symmetric) choleskyLower() *lower {
    l := &lower{a.order, make([]float64, len(a.ele))}
    row, col := 1, 1
    dr := 0 // index of diagonal element at end of row
    dc := 0 // index of diagonal element at top of column
    for i, e := range a.ele {
        if i < dr {
            d := (e - l.ele[i]) / l.ele[dc]
            l.ele[i] = d
            ci, cx := col, dc
            for j := i + 1; j <= dr; j++ {
                cx += ci
                ci++
                l.ele[j] += d * l.ele[cx]
            }
            col++
            dc += col
        } else {
            l.ele[i] = math.Sqrt(e - l.ele[i])
            row++
            dr += row
            col = 1
            dc = 0
        }
    }
    return l
}

func main() {
    demo(&symmetric{3, []float64{
        25,
        15, 18,
        -5, 0, 11}})
    demo(&symmetric{4, []float64{
        18,
        22, 70,
        54, 86, 174,
        42, 62, 134, 106}})
}

func demo(a *symmetric) {
    fmt.Println("A:")
    a.print()
    fmt.Println("L:")
    a.choleskyLower().print()
}
