package main

import (
    "fmt"
    "unicode"
    "unicode/utf8"
)

func main() {
    m := "møøse"
    u := "𝔘𝔫𝔦𝔠𝔬𝔡𝔢"
    j := "J̲o̲s̲é̲"
    fmt.Printf("%d %s %x\n", grLen(m), m, []rune(m))
    fmt.Printf("%d %s %x\n", grLen(u), u, []rune(u))
    fmt.Printf("%d %s %x\n", grLen(j), j, []rune(j))
}

func grLen(s string) int {
    if len(s) == 0 {
        return 0
    }
    gr := 1
    _, s1 := utf8.DecodeRuneInString(s)
    for _, r := range s[s1:] {
        if !unicode.Is(unicode.Mn, r) {
            gr++
        }
    }
    return gr
}
