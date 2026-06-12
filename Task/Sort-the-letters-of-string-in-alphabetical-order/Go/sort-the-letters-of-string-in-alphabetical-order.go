package main

import (
    "fmt"
    "strings"
)

func bubbleSort(s string, trim bool) string { // allow optional removal of whitespace
    chars := []rune(s)
    n := len(chars)
    for {
        n2 := 0
        for i := 1; i < n; i++ {
            if chars[i-1] > chars[i] {
                tmp := chars[i]
                chars[i] = chars[i-1]
                chars[i-1] = tmp
                n2 = i
            }
        }
        n = n2
        if n == 0 {
            break
        }
    }
    s = string(chars)
    if trim {
        s = strings.TrimLeft(s, " \t\r\n")
    }
    return s
}

func main() {
    ss := []string{
        "forever go programming language",
        "Now is the time for all good men to come to the aid of their country.",
    }
    trims := []bool{true, false}
    for i, s := range ss {
        res := bubbleSort(s, trims[i])
        fmt.Printf("Unsorted->%s\n", s)
        fmt.Printf("Sorted  ->%s\n\n", res)
    }
}
