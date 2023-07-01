package main

import (
    "fmt"
    "strings"
)

func main() {
    s := "abracadabra"
    ss := []byte(s)
    var ixs []int
    for ix, c := range s {
        if c == 'a' {
            ixs = append(ixs, ix)
        }
    }
    repl := "ABaCD"
    for i := 0; i < 5; i++ {
        ss[ixs[i]] = repl[i]
    }
    s = string(ss)
    s = strings.Replace(s, "b", "E", 1)
    s = strings.Replace(s, "r", "F", 2)
    s = strings.Replace(s, "F", "r", 1)
    fmt.Println(s)
}
