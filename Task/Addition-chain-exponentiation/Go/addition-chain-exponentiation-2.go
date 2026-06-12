/*
Continued fraction addition chains, as described in "Efficient computation
of addition chains" by F. Bergeron, J. Berstel, and S. Brlek, published in
Journal de théorie des nombres de Bordeaux, 6 no. 1 (1994), p. 21-38,
accessed at http://www.numdam.org/item?id=JTNB_1994__6_1_21_0.
*/
package main

import (
    "fmt"
    "math"
)

// Representation of addition chains.
// Notes:
// 1. While an []int might represent addition chains in general, the
// techniques here work only with "star" chains, as described in the paper.
// Knowledge that the chains are star chains allows certain optimizations.
// 2. The paper descibes a linked list representation which encodes both
// addends of numbers in the chain.  This allows additional optimizations, but
// for the purposes of the RC task, this simpler representation is adequate.
type starChain []int

// ⊗= operator.  modifies receiver.
func (s1 *starChain) cMul(s2 starChain) {
    p := *s1
    i := len(p)
    n := p[i-1]
    p = append(p, s2[1:]...)
    for ; i < len(p); i++ {
        p[i] *= n
    }
    *s1 = p
}

// ⊕= operator.  modifies receiver.
func (p *starChain) cAdd(j int) {
    c := *p
    *p = append(c, c[len(c)-1]+j)
}

// The γ function described in the paper returns a set of numbers in general,
// but certain γ functions return only singletons.  The dichotomic strategy
// is one of these and gives good results so it is the one used for the
// RC task.  Defining the package variable γ to be a singleton allows some
// simplifications in the code.
var γ singleton

type singleton func(int) int

func dichotomic(n int) int {
    return n / (1 << uint((λ(n)+1)/2))
}

// integer log base 2
func λ(n int) (a int) {
    for n != 1 {
        a++
        n >>= 1
    }
    return
}

// minChain as described in the paper.
func minChain(n int) starChain {
    switch a := λ(n); {
    case n == 1<<uint(a):
        r := make(starChain, a+1)
        for i := range r {
            r[i] = 1 << uint(i)
        }
        return r
    case n == 3:
        return starChain{1, 2, 3}
    }
    return chain(n, γ(n))
}

// chain as described in the paper.
func chain(n1, n2 int) starChain {
    q, r := n1/n2, n1%n2
    if r == 0 {
        c := minChain(n2)
        c.cMul(minChain(q))
        return c
    }
    c := chain(n2, r)
    c.cMul(minChain(q))
    c.cAdd(r)
    return c
}

func main() {
    m := 31415
    n := 27182
    show(m)
    show(n)
    show(m * n)
    showEasier(m, 1.00002206445416)
    showEasier(n, 1.00002550055251)
}

func show(e int) {
    fmt.Println("exponent:", e)
    s := math.Sqrt(.5)
    a := matrixFromRows([][]float64{
        {s, 0, s, 0, 0, 0},
        {0, s, 0, s, 0, 0},
        {0, s, 0, -s, 0, 0},
        {-s, 0, s, 0, 0, 0},
        {0, 0, 0, 0, 0, 1},
        {0, 0, 0, 0, 1, 0},
    })
    γ = dichotomic
    sc := minChain(e)
    fmt.Println("addition chain:", sc)
    a.scExp(sc).print("a^e")
    fmt.Println("count of multiplies:", mCount)
    fmt.Println()
}

var mCount int

func showEasier(e int, a float64) {
    fmt.Println("exponent:", e)
    γ = dichotomic
    sc := minChain(e)
    fmt.Printf("%.14f^%d: %.14f\n", a, sc[len(sc)-1], scExp64(a, sc))
    fmt.Println("count of multiplies:", mCount)
    fmt.Println()
}

func scExp64(a float64, sc starChain) float64 {
    mCount = 0
    p := make([]float64, len(sc))
    p[0] = a
    for i := 1; i < len(p); i++ {
        d := sc[i] - sc[i-1]
        j := i - 1
        for sc[j] != d {
            j--
        }
        p[i] = p[i-1] * p[j]
        mCount++
    }
    return p[len(p)-1]
}

func (m *matrix) scExp(sc starChain) *matrix {
    mCount = 0
    p := make([]*matrix, len(sc))
    p[0] = m.copy()
    for i := 1; i < len(p); i++ {
        d := sc[i] - sc[i-1]
        j := i - 1
        for sc[j] != d {
            j--
        }
        p[i] = p[i-1].multiply(p[j])
        mCount++
    }
    return p[len(p)-1]
}

func (m *matrix) copy() *matrix {
    return &matrix{append([]float64{}, m.ele...), m.stride}
}

// code below copied from matrix multiplication task
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
        fmt.Print(heading, "\n")
    }
    for e := 0; e < len(m.ele); e += m.stride {
        fmt.Printf("%6.3f ", m.ele[e:e+m.stride])
        fmt.Println()
    }
}

func (m1 *matrix) multiply(m2 *matrix) (m3 *matrix) {
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
    return m3
}
