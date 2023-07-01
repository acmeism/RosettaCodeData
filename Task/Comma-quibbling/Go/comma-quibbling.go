package main

import (
    "fmt"
    "strings"
)

func q(s []string) string {
    switch len(s) {
    case 0:
        return "{}"
    case 1:
        return "{" + s[0] + "}"
    case 2:
        return "{" + s[0] + " and " + s[1] + "}"
    default:
        return "{" +
            strings.Join(s[:len(s)-1], ", ") +
            " and " +
            s[len(s)-1] +
            "}"
    }
}

func main() {
    fmt.Println(q([]string{}))
    fmt.Println(q([]string{"ABC"}))
    fmt.Println(q([]string{"ABC", "DEF"}))
    fmt.Println(q([]string{"ABC", "DEF", "G", "H"}))
}
