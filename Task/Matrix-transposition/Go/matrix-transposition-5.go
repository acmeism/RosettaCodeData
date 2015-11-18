package main

import "fmt"

type matrix struct {
    stride int
    ele    []float64
}

func main() {
    m := matrix{3, []float64{
        1, 2, 3,
        4, 5, 6,
    }}
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
