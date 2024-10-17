package main

import "core:fmt"
import "core:strings"

// a number of strings
nStr := []string {
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

main :: proc() {
    using fmt

    for s, i in nStr {
        t := strings.fields(s) // tokenize
        // reverse
        last := len(t) - 1
        for k, j in 0..<len(t)/2 {
            t[j], t[last-j] = t[last-j], t[k]
        }
        nStr[i] = strings.join(t, " ")

    }

    // display result
    for t in nStr {
        fmt.println(t)
    }
}
