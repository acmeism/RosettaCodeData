package main

import (
    "fmt"
    "strings"
)

func main() {
    s := "αβγδεζηθ"
    r := []rune(s)
    n, m := 2, 3
    kc := 'δ'  // known character
    ks := "δε" // known string
    // for reference
    fmt.Println("Index: ", "01234567")
    fmt.Println("String:", s)
    // starting from n characters in and of m length
    fmt.Printf("Start %d, length %d:    %s\n", n, m, string(r[n:n+m]))
    // starting from n characters in, up to the end of the string
    fmt.Printf("Start %d, to end:      %s\n", n, string(r[n:]))
    // whole string minus last character
    fmt.Printf("All but last:         %s\n", string(r[:len(r)-1]))
    // starting from a known character within the string and of m length
    dx := strings.IndexRune(s, kc)
    fmt.Printf("Start %q, length %d:  %s\n", kc, m, string([]rune(s[dx:])[:m]))
    // starting from a known substring within the string and of m length
    sx := strings.Index(s, ks)
    fmt.Printf("Start %q, length %d: %s\n", ks, m, string([]rune(s[sx:])[:m]))
}
