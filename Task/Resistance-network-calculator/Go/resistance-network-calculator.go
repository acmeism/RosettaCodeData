package main

import (
    "fmt"
    "math"
    "strconv"
    "strings"
)

func argmax(m [][]float64, i int) int {
    col := make([]float64, len(m))
    max, maxx := -1.0, -1
    for x := 0; x < len(m); x++ {
        col[x] = math.Abs(m[x][i])
        if col[x] > max {
            max = col[x]
            maxx = x
        }
    }
    return maxx
}

func gauss(m [][]float64) []float64 {
    n, p := len(m), len(m[0])
    for i := 0; i < n; i++ {
        k := i + argmax(m[i:n], i)
        m[i], m[k] = m[k], m[i]
        t := 1 / m[i][i]
        for j := i + 1; j < p; j++ {
            m[i][j] *= t
        }
        for j := i + 1; j < n; j++ {
            t = m[j][i]
            for l := i + 1; l < p; l++ {
                m[j][l] -= t * m[i][l]
            }
        }
    }
    for i := n - 1; i >= 0; i-- {
        for j := 0; j < i; j++ {
            m[j][p-1] -= m[j][i] * m[i][p-1]
        }
    }
    col := make([]float64, len(m))
    for x := 0; x < len(m); x++ {
        col[x] = m[x][p-1]
    }
    return col
}

func network(n, k0, k1 int, s string) float64 {
    m := make([][]float64, n)
    for i := 0; i < n; i++ {
        m[i] = make([]float64, n+1)
    }
    for _, resistor := range strings.Split(s, "|") {
        rarr := strings.Fields(resistor)
        a, _ := strconv.Atoi(rarr[0])
        b, _ := strconv.Atoi(rarr[1])
        ri, _ := strconv.Atoi(rarr[2])
        r := 1.0 / float64(ri)
        m[a][a] += r
        m[b][b] += r
        if a > 0 {
            m[a][b] -= r
        }
        if b > 0 {
            m[b][a] -= r
        }
    }
    m[k0][k0] = 1
    m[k1][n] = 1
    return gauss(m)[k1]
}

func main() {
    var fa [4]float64
    fa[0] = network(7, 0, 1, "0 2 6|2 3 4|3 4 10|4 5 2|5 6 8|6 1 4|3 5 6|3 6 6|3 1 8|2 1 8")
    fa[1] = network(9, 0, 8, "0 1 1|1 2 1|3 4 1|4 5 1|6 7 1|7 8 1|0 3 1|3 6 1|1 4 1|4 7 1|2 5 1|5 8 1")
    fa[2] = network(16, 0, 15, "0 1 1|1 2 1|2 3 1|4 5 1|5 6 1|6 7 1|8 9 1|9 10 1|10 11 1|12 13 1|13 14 1|14 15 1|0 4 1|4 8 1|8 12 1|1 5 1|5 9 1|9 13 1|2 6 1|6 10 1|10 14 1|3 7 1|7 11 1|11 15 1")
    fa[3] = network(4, 0, 3, "0 1 150|0 2 50|1 3 300|2 3 250")
    for _, f := range fa {
        fmt.Printf("%.6g\n", f)
    }
}
