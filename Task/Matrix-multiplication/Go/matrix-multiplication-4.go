package main

import "fmt"

type matrix struct {
    stride int
    ele    []float64
}

func (m *matrix) print(heading string) {
    if heading > "" {
        fmt.Print("\n", heading, "\n")
    }
    for e := 0; e < len(m.ele); e += m.stride {
        fmt.Printf("%8.3f ", m.ele[e:e+m.stride])
        fmt.Println()
    }
}

func (m1 *matrix) multiply(m2 *matrix) (m3 *matrix, ok bool) {
    if m1.stride*m2.stride != len(m2.ele) {
        return nil, false
    }
    m3 = &matrix{m2.stride, make([]float64, (len(m1.ele)/m1.stride)*m2.stride)}
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
    a := matrix{4, []float64{
        1, 2, 3, 4,
        5, 6, 7, 8,
    }}
    b := matrix{3, []float64{
        1, 2, 3,
        4, 5, 6,
        7, 8, 9,
        10, 11, 12,
    }}
    p, ok := a.multiply(&b)
    a.print("Matrix A:")
    b.print("Matrix B:")
    if !ok {
        fmt.Println("not conformable for matrix multiplication")
        return
    }
    p.print("Product of A and B:")
}
