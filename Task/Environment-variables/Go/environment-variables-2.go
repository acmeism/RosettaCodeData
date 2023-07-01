package main

import (
    "fmt"
    "os"
    "strings"
)

func main() {
    s := "SHELL"
    se := s + "="
    for _, v := range os.Environ() {
        if strings.HasPrefix(v, se) {
            fmt.Println(s, "has value", v[len(se):])
            return
        }
    }
    fmt.Println(s, "not found")
}
