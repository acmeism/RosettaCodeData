package main

import "fmt"

type md struct {
    dim []int
    ele []float64
}

func newMD(dim ...int) *md {
    n := 1
    for _, d := range dim {
        n *= d
    }
    return &md{append([]int{}, dim...), make([]float64, n)}
}

func (m *md) index(i ...int) (x int) {
    for d, dx := range m.dim {
        x = x*dx + i[d]
    }
    return
}

func (m *md) at(i ...int) float64 {
    return m.ele[m.index(i...)]
}

func (m *md) set(x float64, i ...int) {
    m.ele[m.index(i...)] = x
}

func (m *md) show(i ...int) {
    fmt.Printf("m%d = %g\n", i, m.at(i...))
}

func main() {
    m := newMD(5, 4, 3, 2)
    m.show(4, 3, 2, 1)
    m.set(87, 4, 3, 2, 1)
    m.show(4, 3, 2, 1)

    for i := 0; i < m.dim[0]; i++ {
        for j := 0; j < m.dim[1]; j++ {
            for k := 0; k < m.dim[2]; k++ {
                for l := 0; l < m.dim[3]; l++ {
                    x := m.index(i, j, k, l)
                    m.set(float64(x)+.1, i, j, k, l)
                }
            }
        }
    }
    fmt.Println(m.ele[:10])
    fmt.Println(m.ele[len(m.ele)-10:])
    m.show(4, 3, 2, 1)
}
