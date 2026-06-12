package main

import (
    "fmt"
    "sort"
)

func main() {
    strings := []string{"1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz"}
    u := make(map[rune]int)
    for _, s := range strings {
        m := make(map[rune]int)
        for _, c := range s {
            m[c]++
        }
        for k, v := range m {
            if v == 1 {
                u[k]++
            }
        }
    }
    var chars []rune
    for k, v := range u {
        if v == 3 {
            chars = append(chars, k)
        }
    }
    sort.Slice(chars, func(i, j int) bool { return chars[i] < chars[j] })
    fmt.Println(string(chars))
}
