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
    m.transposeInPlace()
    m.print("transpose:")
}

func (m *matrix) print(heading string) {
    if heading > "" {
        fmt.Print("\n", heading, "\n")
    }
    for e := 0; e < len(m.ele); e += m.stride {
        fmt.Println(m.ele[e : e+m.stride])
    }
}

func (m *matrix) transposeInPlace() {
    h := len(m.ele) / m.stride
    for start := range m.ele {
        next := start
        i := 0
        for {
            i++
            next = (next%h)*m.stride + next/h
            if next <= start {
                break
            }
        }
        if next < start || i == 1 {
            continue
        }

        next = start
        tmp := m.ele[next]
        for {
            i = (next%h)*m.stride + next/h
            if i == start {
                m.ele[next] = tmp
            } else {
                m.ele[next] = m.ele[i]
            }
            next = i
            if next <= start {
                break
            }
        }
    }
    m.stride = h
}
