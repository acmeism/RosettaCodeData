package main

import "fmt"

func levenshtein(s, t string) int {
    if s == "" { return len(t) }
    if t == "" { return len(s) }
    if s[0] == t[0] {
        return levenshtein(s[1:], t[1:])
    }
    a := levenshtein(s[1:], t[1:])
    b := levenshtein(s,     t[1:])
    c := levenshtein(s[1:], t)
    if a > b { a = b }
    if a > c { a = c }
    return a + 1
}

func main() {
    s1 := "rosettacode"
    s2 := "raisethysword"
    fmt.Printf("distance between %s and %s: %d\n", s1, s2,
        levenshtein(s1, s2))
}
