package main

import (
    "fmt"
    "strconv"
    "unicode"
)

func isInt(s string) bool {
    for _, c := range s {
        if !unicode.IsDigit(c) {
            return false
        }
    }
    return true
}

func main() {
    fmt.Println("Are these strings integers?")
    v := "1"
    b := false
    if _, err := strconv.Atoi(v); err == nil {
        b = true
    }
    fmt.Printf("  %3s -> %t\n", v, b)
    i := "one"
    fmt.Printf("  %3s -> %t\n", i, isInt(i))
}
