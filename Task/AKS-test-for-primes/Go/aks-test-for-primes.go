package main

import "fmt"

func bc(p int) []int64 {
    c := make([]int64, p+1)
    r := int64(1)
    for i, half := 0, p/2; i <= half; i++ {
        c[i] = r
        c[p-i] = r
        r = r * int64(p-i) / int64(i+1)
    }
    for i := p - 1; i >= 0; i -= 2 {
        c[i] = -c[i]
    }
    return c
}

func main() {
    for p := 0; p <= 7; p++ {
        fmt.Printf("%d:  %s\n", p, pp(bc(p)))
    }
    for p := 2; p < 50; p++ {
        if aks(p) {
            fmt.Print(p, " ")
        }
    }
    fmt.Println()
}

var e = []rune("²³⁴⁵⁶⁷")

func pp(c []int64) (s string) {
    if len(c) == 1 {
        return fmt.Sprint(c[0])
    }
    p := len(c) - 1
    if c[p] != 1 {
        s = fmt.Sprint(c[p])
    }
    for i := p; i > 0; i-- {
        s += "x"
        if i != 1 {
            s += string(e[i-2])
        }
        if d := c[i-1]; d < 0 {
            s += fmt.Sprintf(" - %d", -d)
        } else {
            s += fmt.Sprintf(" + %d", d)
        }
    }
    return
}

func aks(p int) bool {
    c := bc(p)
    c[p]--
    c[0]++
    for _, d := range c {
        if d%int64(p) != 0 {
            return false
        }
    }
    return true
}
