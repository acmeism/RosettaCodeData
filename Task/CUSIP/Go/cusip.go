package main

import "fmt"

func isCusip(s string) bool {
    if len(s) != 9 { return false }
    sum := 0
    for i := 0; i < 8; i++ {
        c := s[i]
        var v int
        switch {
            case c >= '0' && c <= '9':
                v = int(c) - 48
            case c >= 'A' && c <= 'Z':
                v = int(c) - 55
            case c == '*':
                v = 36
            case c == '@':
                v = 37
            case c == '#':
                v = 38
            default:
                return false
        }
        if i % 2 == 1 { v *= 2 }  // check if odd as using 0-based indexing
        sum += v/10 + v%10
    }
    return int(s[8]) - 48 == (10 - (sum%10)) % 10
}

func main() {
    candidates := []string {
        "037833100",
        "17275R102",
        "38259P508",
        "594918104",
        "68389X106",
        "68389X105",
    }

    for _, candidate := range candidates {
        var b string
        if isCusip(candidate) {
            b = "correct"
        } else {
            b = "incorrect"
        }
        fmt.Printf("%s -> %s\n", candidate, b)
    }
}
