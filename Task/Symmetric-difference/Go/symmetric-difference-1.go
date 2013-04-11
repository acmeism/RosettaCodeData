package main

import "fmt"

var a = map[string]bool{"John": true, "Bob": true, "Mary": true, "Serena": true}
var b = map[string]bool{"Jim": true, "Mary": true, "John": true, "Bob": true}

func main() {
    sd := make(map[string]bool)
    for e := range a {
        if !b[e] {
            sd[e] = true
        }
    }
    for e := range b {
        if !a[e] {
            sd[e] = true
        }
    }
    fmt.Println(sd)
}
