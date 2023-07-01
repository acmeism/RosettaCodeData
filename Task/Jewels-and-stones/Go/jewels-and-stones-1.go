package main

import (
    "fmt"
    "strings"
)

func js(stones, jewels string) (n int) {
    for _, b := range []byte(stones) {
        if strings.IndexByte(jewels, b) >= 0 {
            n++
        }
    }
    return
}

func main() {
    fmt.Println(js("aAAbbbb", "aA"))
}
