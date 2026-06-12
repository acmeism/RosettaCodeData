package main

import (
    "fmt"
    "strings"
)

func removeVowels(s string) string {
    var sb strings.Builder
    vowels := "aeiouAEIOU"
    for _, c := range s {
        if !strings.ContainsAny(string(c), vowels) {
            sb.WriteRune(c)
        }
    }
    return sb.String()
}

func main() {
    s := "Go Programming Language"
    fmt.Println("Input  :", s)
    fmt.Println("Output :", removeVowels(s))
}
