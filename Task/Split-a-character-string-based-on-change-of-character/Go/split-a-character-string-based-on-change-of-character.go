package main

import (
    "fmt"
    "strings"
)

func main() {
    fmt.Println(scc(`gHHH5YY++///\`))
}

func scc(s string) string {
    if len(s) < 2 {
        return s
    }
    var b strings.Builder
    p := s[0]
    b.WriteByte(p)
    for _, c := range []byte(s[1:]) {
        if c != p {
            b.WriteString(", ")
        }
        b.WriteByte(c)
        p = c
    }
    return b.String()
}
