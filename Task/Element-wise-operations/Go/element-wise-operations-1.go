package element

import (
    "fmt"
    "math"
)

type Matrix struct {
    ele    []float64
    stride int
}

func MatrixFromRows(rows [][]float64) Matrix {
    if len(rows) == 0 {
        return Matrix{nil, 0}
    }
    m := Matrix{make([]float64, len(rows)*len(rows[0])), len(rows[0])}
    for rx, row := range rows {
        copy(m.ele[rx*m.stride:(rx+1)*m.stride], row)
    }
    return m
}

func like(m Matrix) Matrix {
    return Matrix{make([]float64, len(m.ele)), m.stride}
}

func (m Matrix) String() string {
    s := ""
    for e := 0; e < len(m.ele); e += m.stride {
        s += fmt.Sprintf("%6.3f \n", m.ele[e:e+m.stride])
    }
    return s
}

type binaryFunc64 func(float64, float64) float64

func elementWiseMM(m1, m2 Matrix, f binaryFunc64) Matrix {
    z := like(m1)
    for i, m1e := range m1.ele {
        z.ele[i] = f(m1e, m2.ele[i])
    }
    return z
}

func elementWiseMS(m Matrix, s float64, f binaryFunc64) Matrix {
    z := like(m)
    for i, e := range m.ele {
        z.ele[i] = f(e, s)
    }
    return z
}

func add(a, b float64) float64 { return a + b }
func sub(a, b float64) float64 { return a - b }
func mul(a, b float64) float64 { return a * b }
func div(a, b float64) float64 { return a / b }
func exp(a, b float64) float64 { return math.Pow(a, b) }

func AddMatrix(m1, m2 Matrix) Matrix { return elementWiseMM(m1, m2, add) }
func SubMatrix(m1, m2 Matrix) Matrix { return elementWiseMM(m1, m2, sub) }
func MulMatrix(m1, m2 Matrix) Matrix { return elementWiseMM(m1, m2, mul) }
func DivMatrix(m1, m2 Matrix) Matrix { return elementWiseMM(m1, m2, div) }
func ExpMatrix(m1, m2 Matrix) Matrix { return elementWiseMM(m1, m2, exp) }

func AddScalar(m Matrix, s float64) Matrix { return elementWiseMS(m, s, add) }
func SubScalar(m Matrix, s float64) Matrix { return elementWiseMS(m, s, sub) }
func MulScalar(m Matrix, s float64) Matrix { return elementWiseMS(m, s, mul) }
func DivScalar(m Matrix, s float64) Matrix { return elementWiseMS(m, s, div) }
func ExpScalar(m Matrix, s float64) Matrix { return elementWiseMS(m, s, exp) }
