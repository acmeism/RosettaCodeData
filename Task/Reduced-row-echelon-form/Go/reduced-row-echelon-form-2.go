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
        fmt.Printf("%6.2f ", m.ele[e:e+m.stride])
        fmt.Println()
    }
}

func (m *matrix) rref() {
    lead := 0
    for rxc0 := 0; rxc0 < len(m.ele); rxc0 += m.stride {
        if lead >= m.stride {
            return
        }
        ixc0 := rxc0
        for m.ele[ixc0+lead] == 0 {
            ixc0 += m.stride
            if ixc0 == len(m.ele) {
                ixc0 = rxc0
                lead++
                if lead == m.stride {
                    return
                }
            }
        }
        for c, ix, rx := 0, ixc0, rxc0; c < m.stride; c++ {
            m.ele[ix], m.ele[rx] = m.ele[rx], m.ele[ix]
            ix++
            rx++
        }
        if d := m.ele[rxc0+lead]; d != 0 {
            d := 1 / d
            for c, rx := 0, rxc0; c < m.stride; c++ {
                m.ele[rx] *= d
                rx++
            }
        }
        for ixc0 = 0; ixc0 < len(m.ele); ixc0 += m.stride {
            if ixc0 != rxc0 {
                f := m.ele[ixc0+lead]
                for c, ix, rx := 0, ixc0, rxc0; c < m.stride; c++ {
                    m.ele[ix] -= m.ele[rx] * f
                    ix++
                    rx++
                }
            }
        }
        lead++
    }
}

func main() {
    m := matrixFromRows([][]float64{
        {1, 2, -1, -4},
        {2, 3, -1, -11},
        {-2, 0, -3, 22},
    })
    m.print("Input:")
    m.rref()
    m.print("Reduced:")
}
