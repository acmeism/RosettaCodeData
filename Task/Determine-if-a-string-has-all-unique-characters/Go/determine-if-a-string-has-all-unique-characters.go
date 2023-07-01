package main

import "fmt"

func analyze(s string) {
    chars := []rune(s)
    le := len(chars)
    fmt.Printf("Analyzing %q which has a length of %d:\n", s, le)
    if le > 1 {
        for i := 0; i < le-1; i++ {
            for j := i + 1; j < le; j++ {
                if chars[j] == chars[i] {
                    fmt.Println("  Not all characters in the string are unique.")
                    fmt.Printf("  %q (%#[1]x) is duplicated at positions %d and %d.\n\n", chars[i], i+1, j+1)
                    return
                }
            }
        }
    }
    fmt.Println("  All characters in the string are unique.\n")
}

func main() {
    strings := []string{
        "",
        ".",
        "abcABC",
        "XYZ ZYX",
        "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ",
        "01234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ0X",
        "hétérogénéité",
        "🎆🎃🎇🎈",
        "😍😀🙌💃😍🙌",
        "🐠🐟🐡🦈🐬🐳🐋🐡",
    }
    for _, s := range strings {
        analyze(s)
    }
}
