package main

import (
    "fmt"
    "math/big"
    "strconv"
    "strings"
)

// Adds thousand separators to an integral string.
func commatize(s string) string {
    neg := false
    if strings.HasPrefix(s, "-") {
        s = s[1:]
        neg = true
    }
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    if !neg {
        return s
    }
    return "-" + s
}

func main() {
    fmt.Println(" n  smallest power of 6 which contains n")
    six := big.NewInt(6)
    for n := 0; n <= 21; n++ {
        ns := strconv.Itoa(n)
        i := int64(0)
        for {
            bi := big.NewInt(i)
            pow6 := bi.Exp(six, bi, nil).String()
            if strings.Contains(pow6, ns) {
                fmt.Printf("%2d  6^%-2d = %s\n", n, i, commatize(pow6))
                break
            }
            i++
        }
    }
}
