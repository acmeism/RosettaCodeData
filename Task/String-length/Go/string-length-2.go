package main

import (
    "fmt"
    "unicode/utf8"
)

func main() {
    m := "møøse"
    u := "𝔘𝔫𝔦𝔠𝔬𝔡𝔢"
    j := "J̲o̲s̲é̲"
    fmt.Printf("%d %s %x\n", utf8.RuneCountInString(m), m, []rune(m))
    fmt.Printf("%d %s %x\n", utf8.RuneCountInString(u), u, []rune(u))
    fmt.Printf("%d %s %x\n", utf8.RuneCountInString(j), j, []rune(j))
}
