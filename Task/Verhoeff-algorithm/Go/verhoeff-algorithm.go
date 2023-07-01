package main

import "fmt"

var d = [][]int{
    {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
    {1, 2, 3, 4, 0, 6, 7, 8, 9, 5},
    {2, 3, 4, 0, 1, 7, 8, 9, 5, 6},
    {3, 4, 0, 1, 2, 8, 9, 5, 6, 7},
    {4, 0, 1, 2, 3, 9, 5, 6, 7, 8},
    {5, 9, 8, 7, 6, 0, 4, 3, 2, 1},
    {6, 5, 9, 8, 7, 1, 0, 4, 3, 2},
    {7, 6, 5, 9, 8, 2, 1, 0, 4, 3},
    {8, 7, 6, 5, 9, 3, 2, 1, 0, 4},
    {9, 8, 7, 6, 5, 4, 3, 2, 1, 0},
}

var inv = []int{0, 4, 3, 2, 1, 5, 6, 7, 8, 9}

var p = [][]int{
    {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
    {1, 5, 7, 6, 2, 8, 3, 0, 9, 4},
    {5, 8, 0, 3, 7, 9, 6, 1, 4, 2},
    {8, 9, 1, 6, 0, 4, 3, 5, 2, 7},
    {9, 4, 5, 3, 1, 2, 6, 8, 7, 0},
    {4, 2, 8, 6, 5, 7, 3, 9, 0, 1},
    {2, 7, 9, 3, 8, 0, 6, 4, 1, 5},
    {7, 0, 4, 6, 9, 1, 3, 2, 5, 8},
}

func verhoeff(s string, validate, table bool) interface{} {
    if table {
        t := "Check digit"
        if validate {
            t = "Validation"
        }
        fmt.Printf("%s calculations for '%s':\n\n", t, s)
        fmt.Println(" i  nᵢ  p[i,nᵢ]  c")
        fmt.Println("------------------")
    }
    if !validate {
        s = s + "0"
    }
    c := 0
    le := len(s) - 1
    for i := le; i >= 0; i-- {
        ni := int(s[i] - 48)
        pi := p[(le-i)%8][ni]
        c = d[c][pi]
        if table {
            fmt.Printf("%2d  %d      %d     %d\n", le-i, ni, pi, c)
        }
    }
    if table && !validate {
        fmt.Printf("\ninv[%d] = %d\n", c, inv[c])
    }
    if !validate {
        return inv[c]
    }
    return c == 0
}

func main() {
    ss := []string{"236", "12345", "123456789012"}
    ts := []bool{true, true, false, true}
    for i, s := range ss {
        c := verhoeff(s, false, ts[i]).(int)
        fmt.Printf("\nThe check digit for '%s' is '%d'\n\n", s, c)
        for _, sc := range []string{s + string(c+48), s + "9"} {
            v := verhoeff(sc, true, ts[i]).(bool)
            ans := "correct"
            if !v {
                ans = "incorrect"
            }
            fmt.Printf("\nThe validation for '%s' is %s\n\n", sc, ans)
        }
    }
}
