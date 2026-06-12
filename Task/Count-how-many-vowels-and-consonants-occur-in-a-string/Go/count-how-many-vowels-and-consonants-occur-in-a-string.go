package main

import (
    "fmt"
    "strings"
)

func main() {
    const (
        vowels     = "aeiou"
        consonants = "bcdfghjklmnpqrstvwxyz"
    )
    strs := []string{
        "Forever Go programming language",
        "Now is the time for all good men to come to the aid of their country.",
    }
    for _, str := range strs {
        fmt.Println(str)
        str = strings.ToLower(str)
        vc, cc := 0, 0
        vmap := make(map[rune]bool)
        cmap := make(map[rune]bool)
        for _, c := range str {
            if strings.ContainsRune(vowels, c) {
                vc++
                vmap[c] = true
            } else if strings.ContainsRune(consonants, c) {
                cc++
                cmap[c] = true
            }
        }
        fmt.Printf("contains (total) %d vowels and %d consonants.\n", vc, cc)
        fmt.Printf("contains (distinct %d vowels and %d consonants.\n\n", len(vmap), len(cmap))
    }
}
