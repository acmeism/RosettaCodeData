package main

import (
    "fmt"
    "log"
    "math"
)

type Matrix [][]float64

func (m Matrix) rows() int { return len(m) }
func (m Matrix) cols() int { return len(m[0]) }

func (m Matrix) add(m2 Matrix) Matrix {
    if m.rows() != m2.rows() || m.cols() != m2.cols() {
        log.Fatal("Matrices must have the same dimensions.")
    }
    c := make(Matrix, m.rows())
    for i := 0; i < m.rows(); i++ {
        c[i] = make([]float64, m.cols())
        for j := 0; j < m.cols(); j++ {
            c[i][j] = m[i][j] + m2[i][j]
        }
    }
    return c
}

func (m Matrix) sub(m2 Matrix) Matrix {
    if m.rows() != m2.rows() || m.cols() != m2.cols() {
        log.Fatal("Matrices must have the same dimensions.")
    }
    c := make(Matrix, m.rows())
    for i := 0; i < m.rows(); i++ {
        c[i] = make([]float64, m.cols())
        for j := 0; j < m.cols(); j++ {
            c[i][j] = m[i][j] - m2[i][j]
        }
    }
    return c
}

func (m Matrix) mul(m2 Matrix) Matrix {
    if m.cols() != m2.rows() {
        log.Fatal("Cannot multiply these matrices.")
    }
    c := make(Matrix, m.rows())
    for i := 0; i < m.rows(); i++ {
        c[i] = make([]float64, m2.cols())
        for j := 0; j < m2.cols(); j++ {
            for k := 0; k < m2.rows(); k++ {
                c[i][j] += m[i][k] * m2[k][j]
            }
        }
    }
    return c
}

func (m Matrix) toString(p int) string {
    s := make([]string, m.rows())
    pow := math.Pow(10, float64(p))
    for i := 0; i < m.rows(); i++ {
        t := make([]string, m.cols())
        for j := 0; j < m.cols(); j++ {
            r := math.Round(m[i][j]*pow) / pow
            t[j] = fmt.Sprintf("%g", r)
            if t[j] == "-0" {
                t[j] = "0"
            }
        }
        s[i] = fmt.Sprintf("%v", t)
    }
    return fmt.Sprintf("%v", s)
}

func params(r, c int) [4][6]int {
    return [4][6]int{
        {0, r, 0, c, 0, 0},
        {0, r, c, 2 * c, 0, c},
        {r, 2 * r, 0, c, r, 0},
        {r, 2 * r, c, 2 * c, r, c},
    }
}

func toQuarters(m Matrix) [4]Matrix {
    r := m.rows() / 2
    c := m.cols() / 2
    p := params(r, c)
    var quarters [4]Matrix
    for k := 0; k < 4; k++ {
        q := make(Matrix, r)
        for i := p[k][0]; i < p[k][1]; i++ {
            q[i-p[k][4]] = make([]float64, c)
            for j := p[k][2]; j < p[k][3]; j++ {
                q[i-p[k][4]][j-p[k][5]] = m[i][j]
            }
        }
        quarters[k] = q
    }
    return quarters
}

func fromQuarters(q [4]Matrix) Matrix {
    r := q[0].rows()
    c := q[0].cols()
    p := params(r, c)
    r *= 2
    c *= 2
    m := make(Matrix, r)
    for i := 0; i < c; i++ {
        m[i] = make([]float64, c)
    }
    for k := 0; k < 4; k++ {
        for i := p[k][0]; i < p[k][1]; i++ {
            for j := p[k][2]; j < p[k][3]; j++ {
                m[i][j] = q[k][i-p[k][4]][j-p[k][5]]
            }
        }
    }
    return m
}

func strassen(a, b Matrix) Matrix {
    if a.rows() != a.cols() || b.rows() != b.cols() || a.rows() != b.rows() {
        log.Fatal("Matrices must be square and of equal size.")
    }
    if a.rows() == 0 || (a.rows()&(a.rows()-1)) != 0 {
        log.Fatal("Size of matrices must be a power of two.")
    }
    if a.rows() == 1 {
        return a.mul(b)
    }
    qa := toQuarters(a)
    qb := toQuarters(b)
    p1 := strassen(qa[1].sub(qa[3]), qb[2].add(qb[3]))
    p2 := strassen(qa[0].add(qa[3]), qb[0].add(qb[3]))
    p3 := strassen(qa[0].sub(qa[2]), qb[0].add(qb[1]))
    p4 := strassen(qa[0].add(qa[1]), qb[3])
    p5 := strassen(qa[0], qb[1].sub(qb[3]))
    p6 := strassen(qa[3], qb[2].sub(qb[0]))
    p7 := strassen(qa[2].add(qa[3]), qb[0])
    var q [4]Matrix
    q[0] = p1.add(p2).sub(p4).add(p6)
    q[1] = p4.add(p5)
    q[2] = p6.add(p7)
    q[3] = p2.sub(p3).add(p5).sub(p7)
    return fromQuarters(q)
}

func main() {
    a := Matrix{{1, 2}, {3, 4}}
    b := Matrix{{5, 6}, {7, 8}}
    c := Matrix{{1, 1, 1, 1}, {2, 4, 8, 16}, {3, 9, 27, 81}, {4, 16, 64, 256}}
    d := Matrix{{4, -3, 4.0 / 3, -1.0 / 4}, {-13.0 / 3, 19.0 / 4, -7.0 / 3, 11.0 / 24},
        {3.0 / 2, -2, 7.0 / 6, -1.0 / 4}, {-1.0 / 6, 1.0 / 4, -1.0 / 6, 1.0 / 24}}
    e := Matrix{{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}, {13, 14, 15, 16}}
    f := Matrix{{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}}
    fmt.Println("Using 'normal' matrix multiplication:")
    fmt.Printf("  a * b = %v\n", a.mul(b))
    fmt.Printf("  c * d = %v\n", c.mul(d).toString(6))
    fmt.Printf("  e * f = %v\n", e.mul(f))
    fmt.Println("\nUsing 'Strassen' matrix multiplication:")
    fmt.Printf("  a * b = %v\n", strassen(a, b))
    fmt.Printf("  c * d = %v\n", strassen(c, d).toString(6))
    fmt.Printf("  e * f = %v\n", strassen(e, f))
}
