package main

import (
    "fmt"
    "strings"
)

func main() {
    s := "ABCDEFGH"
    n, m := 2, 3
    // for reference
    fmt.Println("Index: ", "01234567")
    fmt.Println("String:", s)
    // starting from n characters in and of m length
    fmt.Printf("Start %d, length %d:    %s\n", n, m, s[n : n+m])
    // starting from n characters in, up to the end of the string
    fmt.Printf("Start %d, to end:      %s\n", n, s[n:])
    // whole string minus last character
    fmt.Printf("All but last:         %s\n", s[:len(s)-1])
    // starting from a known character within the string and of m length
    dx := strings.IndexByte(s, 'D')
    fmt.Printf("Start 'D', length %d:  %s\n", m, s[dx : dx+m])
    // starting from a known substring within the string and of m length
    sx := strings.Index(s, "DE")
    fmt.Printf(`Start "DE", length %d: %s`+"\n", m, s[sx : sx+m])
}
