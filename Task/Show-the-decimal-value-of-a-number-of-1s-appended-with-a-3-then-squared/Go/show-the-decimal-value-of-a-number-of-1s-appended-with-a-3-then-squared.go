package main

import (
    "fmt"
    "strconv"
    "strings"
)

func a(n int) {
    s, _ := strconv.Atoi(strings.Repeat("1", n) + "3")
    t := s * s
    fmt.Printf("%d %d\n", s, t)
}

func main() {
    for n := 0; n <= 7; n++ {
        a(n)
    }
}
