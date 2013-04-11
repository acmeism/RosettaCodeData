package main

import "fmt"

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

func (m *matrix) print(heading string) {
    if heading > "" {
        fmt.Print("\n", heading, "\n")
    }
    for e := 0; e < len(m.ele); e += m.stride {
        fmt.Printf("%6.3f ", m.ele[e:e+m.stride])
        fmt.Println()
    }
}

func (m1 *matrix) multiply(m2 *matrix) (m3 *matrix, ok bool) {
    if m1.stride*m2.stride != len(m2.ele) {
        return nil, false
    }
    m3 = &matrix{make([]float64, (len(m1.ele)/m1.stride)*m2.stride), m2.stride}
    for m1c0, m3x := 0, 0; m1c0 < len(m1.ele); m1c0 += m1.stride {
        for m2r0 := 0; m2r0 < m2.stride; m2r0++ {
            for m1x, m2x := m1c0, m2r0; m2x < len(m2.ele); m2x += m2.stride {
                m3.ele[m3x] += m1.ele[m1x] * m2.ele[m2x]
                m1x++
            }
            m3x++
        }
    }
    return m3, true
}

func main() {
    a := matrixFromRows([][]float64{
        {1, 1, 1, 1},
        {2, 4, 8, 16},
        {3, 9, 27, 81},
        {4, 16, 64, 256},
    })
    b := matrixFromRows([][]float64{
        {
            4,
            -3,
            4. / 3,
            -1. / 4,
        },
        {
            -13. / 3,
            19. / 4,
            -7. / 3,
            11. / 24,
        },
        {
            3. / 2,
            -2,
            7. / 6,
            -1. / 4,
        },
        {
            -1. / 6,
            1. / 4,
            -1. / 6,
            1. / 24,
        },
    })
    p, ok := a.multiply(b)
    a.print("Matrix A:")
    b.print("Matrix B:")
    if !ok {
        fmt.Println("not conformable for matrix multiplication")
        return
    }
    p.print("Product of A and B:")
}
