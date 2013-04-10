package main

import (
    "fmt"
    "math"
)

type matrix struct {
    ele    []float64
    stride int
}

func matrixFromRows(rows [][]float64) *matrix {
    if len(rows) == 0 {
        return &matrix{nil, 0}
    }
    m := &matrix{make([]float64, len(rows)*len(rows[0])), len(rows[0])}
    for rx, row := range rows {
        copy(m.ele[rx*m.stride:(rx+1)*m.stride], row)
    }
    return m
}

func like(m *matrix) *matrix {
    return &matrix{make([]float64, len(m.ele)), m.stride}
}

func (m *matrix) print(heading string) {
    if heading > "" {
        fmt.Print("\n", heading, "\n")
    }
    for e := 0; e < len(m.ele); e += m.stride {
        fmt.Printf("%6.3f ", m.ele[e:e+m.stride])
        fmt.Println()
    }
}

type binaryFunc64 func(float64, float64) float64

func elementWiseMM(m1, m2 *matrix, f binaryFunc64) *matrix {
    z := like(m1)
    for i, m1e := range m1.ele {
        z.ele[i] = f(m1e, m2.ele[i])
    }
    return z
}

func elementWiseMS(m *matrix, s float64, f binaryFunc64) *matrix {
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

func ewmmAdd(m1, m2 *matrix) *matrix { return elementWiseMM(m1, m2, add) }
func ewmmSub(m1, m2 *matrix) *matrix { return elementWiseMM(m1, m2, sub) }
func ewmmMul(m1, m2 *matrix) *matrix { return elementWiseMM(m1, m2, mul) }
func ewmmDiv(m1, m2 *matrix) *matrix { return elementWiseMM(m1, m2, div) }
func ewmmExp(m1, m2 *matrix) *matrix { return elementWiseMM(m1, m2, exp) }

func ewmsAdd(m *matrix, s float64) *matrix { return elementWiseMS(m, s, add) }
func ewmsSub(m *matrix, s float64) *matrix { return elementWiseMS(m, s, sub) }
func ewmsMul(m *matrix, s float64) *matrix { return elementWiseMS(m, s, mul) }
func ewmsDiv(m *matrix, s float64) *matrix { return elementWiseMS(m, s, div) }
func ewmsExp(m *matrix, s float64) *matrix { return elementWiseMS(m, s, exp) }

func main() {
    m1 := matrixFromRows([][]float64{{3, 1, 4}, {1, 5, 9}})
    m2 := matrixFromRows([][]float64{{2, 7, 1}, {8, 2, 8}})
    m1.print("m1:")
    m2.print("m2:")
    ewmmAdd(m1, m2).print("m1 + m2:")
    ewmmSub(m1, m2).print("m1 - m2:")
    ewmmMul(m1, m2).print("m1 * m2:")
    ewmmDiv(m1, m2).print("m1 / m2:")
    ewmmExp(m1, m2).print("m1 ^ m2:")
    s := .5
    fmt.Println("\ns:", s)
    ewmsAdd(m1, s).print("m1 + s:")
    ewmsSub(m1, s).print("m1 - s:")
    ewmsMul(m1, s).print("m1 * s:")
    ewmsDiv(m1, s).print("m1 / s:")
    ewmsExp(m1, s).print("m1 ^ s:")
}
