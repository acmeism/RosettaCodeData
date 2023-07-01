package main

import (
    "fmt"
    "strings"
)

func lcs(x, y string) string {
    xl, yl := len(x), len(y)
    if xl == 0 || yl == 0 {
        return ""
    }
    x1, y1 := x[:xl-1], y[:yl-1]
    if x[xl-1] == y[yl-1] {
        return fmt.Sprintf("%s%c", lcs(x1, y1), x[xl-1])
    }
    x2, y2 := lcs(x, y1), lcs(x1, y)
    if len(x2) > len(y2) {
        return x2
    } else {
        return y2
    }
}

func scs(u, v string) string {
    ul, vl := len(u), len(v)
    lcs := lcs(u, v)
    ui, vi := 0, 0
    var sb strings.Builder
    for i := 0; i < len(lcs); i++ {
        for ui < ul && u[ui] != lcs[i] {
            sb.WriteByte(u[ui])
            ui++
        }
        for vi < vl && v[vi] != lcs[i] {
            sb.WriteByte(v[vi])
            vi++
        }
        sb.WriteByte(lcs[i])
        ui++
        vi++
    }
    if ui < ul {
        sb.WriteString(u[ui:])
    }
    if vi < vl {
        sb.WriteString(v[vi:])
    }
    return sb.String()
}

func main() {
    u := "abcbdab"
    v := "bdcaba"
    fmt.Println(scs(u, v))
}
