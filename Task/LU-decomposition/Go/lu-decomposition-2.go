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
        fmt.Printf("%8.5f ", m.ele[e:e+m.stride])
        fmt.Println()
    }
}

func (m1 *matrix) mul(m2 *matrix) (m3 *matrix, ok bool) {
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

func zero(rows, cols int) *matrix {
    return &matrix{cols, make([]float64, rows*cols)}
}

func eye(n int) *matrix {
    m := zero(n, n)
    for ix := 0; ix < len(m.ele); ix += n + 1 {
        m.ele[ix] = 1
    }
    return m
}

func (a *matrix) pivotize() *matrix {
    pv := make([]int, a.stride)
    for i := range pv {
        pv[i] = i
    }
    for j, dx := 0, 0; j < a.stride; j++ {
        row := j
        max := a.ele[dx]
        for i, ixcj := j, dx; i < a.stride; i++ {
            if a.ele[ixcj] > max {
                max = a.ele[ixcj]
                row = i
            }
            ixcj += a.stride
        }
        if j != row {
            pv[row], pv[j] = pv[j], pv[row]
        }
        dx += a.stride + 1
    }
    p := zero(a.stride, a.stride)
    for r, c := range pv {
        p.ele[r*a.stride+c] = 1
    }
    return p
}

func (a *matrix) lu() (l, u, p *matrix) {
    l = zero(a.stride, a.stride)
    u = zero(a.stride, a.stride)
    p = a.pivotize()
    a, _ = p.mul(a)
    for j, jxc0 := 0, 0; j < a.stride; j++ {
        l.ele[jxc0+j] = 1
        for i, ixc0 := 0, 0; ixc0 <= jxc0; i++ {
            sum := 0.
            for k, kxcj := 0, j; k < i; k++ {
                sum += u.ele[kxcj] * l.ele[ixc0+k]
                kxcj += a.stride
            }
            u.ele[ixc0+j] = a.ele[ixc0+j] - sum
            ixc0 += a.stride
        }
        for ixc0 := jxc0; ixc0 < len(a.ele); ixc0 += a.stride {
            sum := 0.
            for k, kxcj := 0, j; k < j; k++ {
                sum += u.ele[kxcj] * l.ele[ixc0+k]
                kxcj += a.stride
            }
            l.ele[ixc0+j] = (a.ele[ixc0+j] - sum) / u.ele[jxc0+j]
        }
        jxc0 += a.stride
    }
    return
}

func main() {
    showLU(&matrix{3, []float64{
        1, 3, 5,
        2, 4, 7,
        1, 1, 0}})
    showLU(&matrix{4, []float64{
        11, 9, 24, 2,
        1, 5, 2, 6,
        3, 17, 18, 1,
        2, 5, 7, 1}})
}

func showLU(a *matrix) {
    a.print("\na")
    l, u, p := a.lu()
    l.print("l")
    u.print("u")
    p.print("p")
}
