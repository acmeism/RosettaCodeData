package main

import "fmt"

func analyze(s string) {
    chars := []rune(s)
    le := len(chars)
    fmt.Printf("Analyzing %q which has a length of %d:\n", s, le)
    if le > 1 {
        for i := 1; i < le; i++ {
            if chars[i] != chars[i-1] {
                fmt.Println("  Not all characters in the string are the same.")
                fmt.Printf("  %q (%#[1]x) is different at position %d.\n\n", chars[i], i+1)
                return
            }
        }
    }
    fmt.Println("  All characters in the string are the same.\n")
}

func main() {
    strings := []string{
        "",
        "   ",
        "2",
        "333",
        ".55",
        "tttTTT",
        "4444 444k",
        "pépé",
        "🐶🐶🐺🐶",
        "🎄🎄🎄🎄",
    }
    for _, s := range strings {
        analyze(s)
    }
}
