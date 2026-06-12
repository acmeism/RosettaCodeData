package main

import (
    "fmt"
    "sort"
)

func main() {
    strings := []string{"133252abcdeeffd", "a6789798st", "yxcdfgxcyz"}
    m := make(map[rune]int)
    for _, s := range strings {
        for _, c := range s {
            m[c]++
        }
    }
    var chars []rune
    for k, v := range m {
        if v == 1 {
            chars = append(chars, k)
        }
    }
    sort.Slice(chars, func(i, j int) bool { return chars[i] < chars[j] })
    fmt.Println(string(chars))
}
