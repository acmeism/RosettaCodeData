package main

import (
    "fmt"
    "strconv"
)

func main() {
    i := int64(1)
    for {
        b2 := strconv.FormatInt(i, 2)
        b2 += b2
        d, _ := strconv.ParseInt(b2, 2, 64)
        if d >= 1000 {
            break
        }
        fmt.Printf("%3d : %s\n", d, b2)
        i++
    }
    fmt.Println("\nFound", i-1, "numbers.")
}
