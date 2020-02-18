package main

import (
    "fmt"
    "strconv"
)

func isNumeric(s string) bool {
    _, err := strconv.ParseFloat(s, 64)
    return err == nil
}

func main() {
    fmt.Println("Are these strings numeric?")
    strings := []string{"1", "3.14", "-100", "1e2", "NaN", "rose"}
    for _, s := range strings {
        fmt.Printf("  %4s -> %t\n", s, isNumeric(s))
    }
}
