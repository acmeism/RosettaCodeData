package main

import "fmt"

type matrix struct {
    ele    []float64
    stride int
}

// construct new matrix from slice of slices
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

func main() {
    m := matrixFromRows([][]float64{
        {1, 2, 3},
        {4, 5, 6},
    })
    m.print("original:")
    m.transpose().print("transpose:")
}

func (m *matrix) print(heading string) {
    if heading > "" {
        fmt.Print("\n", heading, "\n")
    }
    for e := 0; e < len(m.ele); e += m.stride {
        fmt.Println(m.ele[e : e+m.stride])
    }
}

func (m *matrix) transpose() *matrix {
    r := &matrix{make([]float64, len(m.ele)), len(m.ele) / m.stride}
    rx := 0
    for _, e := range m.ele {
        r.ele[rx] = e
        rx += r.stride
        if rx >= len(r.ele) {
            rx -= len(r.ele) - 1
        }
    }
    return r
}
