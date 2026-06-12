package main

import (
    "fmt"
    "strconv"
    "strings"
)

func main() {
    const nondecimal = "abcdef"
    c := 0
    for i := int64(0); i <= 500; i++ {
        hex := strconv.FormatInt(i, 16)
        if strings.ContainsAny(nondecimal, hex) {
            fmt.Printf("%3d ", i)
            c++
            if c%15 == 0 {
                fmt.Println()
            }
        }
    }
    fmt.Printf("\n\n%d such numbers found.\n", c)
}
