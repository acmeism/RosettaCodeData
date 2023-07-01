package main

import (
    "fmt"
    "strconv"
)

func uabs(a, b uint64) uint64 {
    if a > b {
        return a - b
    }
    return b - a
}

func isEsthetic(n, b uint64) bool {
    if n == 0 {
        return false
    }
    i := n % b
    n /= b
    for n > 0 {
        j := n % b
        if uabs(i, j) != 1 {
            return false
        }
        n /= b
        i = j
    }
    return true
}

var esths []uint64

func dfs(n, m, i uint64) {
    if i >= n && i <= m {
        esths = append(esths, i)
    }
    if i == 0 || i > m {
        return
    }
    d := i % 10
    i1 := i*10 + d - 1
    i2 := i1 + 2
    if d == 0 {
        dfs(n, m, i2)
    } else if d == 9 {
        dfs(n, m, i1)
    } else {
        dfs(n, m, i1)
        dfs(n, m, i2)
    }
}

func listEsths(n, n2, m, m2 uint64, perLine int, all bool) {
    esths = esths[:0]
    for i := uint64(0); i < 10; i++ {
        dfs(n2, m2, i)
    }
    le := len(esths)
    fmt.Printf("Base 10: %s esthetic numbers between %s and %s:\n",
        commatize(uint64(le)), commatize(n), commatize(m))
    if all {
        for c, esth := range esths {
            fmt.Printf("%d ", esth)
            if (c+1)%perLine == 0 {
                fmt.Println()
            }
        }
    } else {
        for i := 0; i < perLine; i++ {
            fmt.Printf("%d ", esths[i])
        }
        fmt.Println("\n............\n")
        for i := le - perLine; i < le; i++ {
            fmt.Printf("%d ", esths[i])
        }
    }
    fmt.Println("\n")
}

func commatize(n uint64) string {
    s := fmt.Sprintf("%d", n)
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    return s
}

func main() {
    for b := uint64(2); b <= 16; b++ {
        fmt.Printf("Base %d: %dth to %dth esthetic numbers:\n", b, 4*b, 6*b)
        for n, c := uint64(1), uint64(0); c < 6*b; n++ {
            if isEsthetic(n, b) {
                c++
                if c >= 4*b {
                    fmt.Printf("%s ", strconv.FormatUint(n, int(b)))
                }
            }
        }
        fmt.Println("\n")
    }

    // the following all use the obvious range limitations for the numbers in question
    listEsths(1000, 1010, 9999, 9898, 16, true)
    listEsths(1e8, 101_010_101, 13*1e7, 123_456_789, 9, true)
    listEsths(1e11, 101_010_101_010, 13*1e10, 123_456_789_898, 7, false)
    listEsths(1e14, 101_010_101_010_101, 13*1e13, 123_456_789_898_989, 5, false)
    listEsths(1e17, 101_010_101_010_101_010, 13*1e16, 123_456_789_898_989_898, 4, false)
}
