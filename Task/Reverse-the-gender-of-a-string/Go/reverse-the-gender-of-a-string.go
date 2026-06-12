package main

import (
    "fmt"
    "strings"
)

func reverseGender(s string) string {
    if strings.Contains(s, "She") {
        return strings.Replace(s, "She", "He", -1)
    } else if strings.Contains(s, "He") {
        return strings.Replace(s, "He", "She", -1)
    }
    return s
}

func main() {
    s := "She was a soul stripper. She took my heart!"
    t := reverseGender(s)
    fmt.Println(t)
    fmt.Println(reverseGender(t))
}
