package main

import (
    "fmt"
    "strings"
)

func rep(s string) int {
    for x := len(s) / 2; x > 0; x-- {
        if strings.HasPrefix(s, s[x:]) {
            return x
        }
    }
    return 0
}

const m = `
1001110011
1110111011
0010010010
1010101010
1111111111
0100101101
0100100
101
11
00
1`

func main() {
    for _, s := range strings.Fields(m) {
        if n := rep(s); n > 0 {
            fmt.Printf("%q  %d rep-string %q\n", s, n, s[:n])
        } else {
            fmt.Printf("%q  not a rep-string\n", s)
        }
    }
}
