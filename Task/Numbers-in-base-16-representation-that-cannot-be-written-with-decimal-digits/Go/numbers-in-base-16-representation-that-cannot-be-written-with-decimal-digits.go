package main

import (
    "fmt"
    "strconv"
    "strings"
)

func main() {
    const decimal = "0123456789"
    c := 0
    for i := int64(1); i < 500; i++ {
        hex := strconv.FormatInt(i, 16)
        if !strings.ContainsAny(decimal, hex) {
            fmt.Printf("%3d ", i)
            c++
            if c%14 == 0 {
                fmt.Println()
            }
        }
    }
    fmt.Printf("\n%d such numbers found.\n", c)
}
