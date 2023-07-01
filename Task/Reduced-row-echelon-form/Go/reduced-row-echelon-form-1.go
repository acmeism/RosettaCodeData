package main

import "fmt"

type matrix [][]float64

func (m matrix) print() {
    for _, r := range m {
        fmt.Println(r)
    }
    fmt.Println("")
}

func main() {
    m := matrix{
        { 1, 2, -1,  -4},
        { 2, 3, -1, -11},
        {-2, 0, -3,  22},
    }
    m.print()
    rref(m)
    m.print()
}

func rref(m matrix) {
    lead := 0
    rowCount := len(m)
    columnCount := len(m[0])
    for r := 0; r < rowCount; r++ {
        if lead >= columnCount {
            return
        }
        i := r
        for m[i][lead] == 0 {
            i++
            if rowCount == i {
                i = r
                lead++
                if columnCount == lead {
                    return
                }
            }
        }
        m[i], m[r] = m[r], m[i]
        f := 1 / m[r][lead]
        for j, _ := range m[r] {
            m[r][j] *= f
        }
        for i = 0; i < rowCount; i++ {
            if i != r {
                f = m[i][lead]
                for j, e := range m[r] {
                    m[i][j] -= e * f
                }
            }
        }
        lead++
    }
}
