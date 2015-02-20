package main

import (
    "fmt"
    "strings"
)

// a number of strings
var n = []string{
    "---------- Ice and Fire ------------",
    "                                    ",
    "fire, in end will world the say Some",
    "ice. in say Some                    ",
    "desire of tasted I've what From     ",
    "fire. favor who those with hold I   ",
    "                                    ",
    "... elided paragraph last ...       ",
    "                                    ",
    "Frost Robert -----------------------",
}

func main() {
    for i, s := range n {
        t := strings.Fields(s) // tokenize
        // reverse
        last := len(t) - 1
        for j, k := range t[:len(t)/2] {
            t[j], t[last-j] = t[last-j], k
        }
        n[i] = strings.Join(t, " ")
    }
    // display result
    for _, t := range n {
        fmt.Println(t)
    }
}
