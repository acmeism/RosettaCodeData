package main

import "fmt"

func substrings(s string) []string {
    n := len(s)
    if n == 0 {
        return []string{""}
    }
    var ss []string
    for i := 0; i < n; i++ {
        for le := 1; le <= n-i; le++ {
            ss = append(ss, s[i:i+le])
        }
    }
    return ss
}

func distinctRunes(chars []rune) []rune {
    m := make(map[rune]bool)
    for _, char := range chars {
        m[char] = true
    }
    var l []rune
    for k := range m {
        l = append(l, k)
    }
    return l
}

func distinctStrings(strings []string) []string {
    m := make(map[string]bool)
    for _, str := range strings {
        m[str] = true
    }
    var l []string
    for k := range m {
        l = append(l, k)
    }
    return l
}

func main() {
    fmt.Println("The longest substring(s) of the following without repeating characters are:\n")
    strs := []string{"xyzyabcybdfd", "xyzyab", "zzzzz", "a", ""}
    for _, s := range strs {
        var longest []string
        longestLen := 0
        for _, ss := range substrings(s) {
            if len(distinctRunes([]rune(ss))) == len(ss) {
                if len(ss) >= longestLen {
                    if len(ss) > longestLen {
                        longest = longest[:0]
                        longestLen = len(ss)
                    }
                    longest = append(longest, ss)
                }
            }
        }
        longest = distinctStrings(longest)
        fmt.Printf("String = '%s'\n", s)
        fmt.Println(longest)
        fmt.Printf("Length = %d\n\n", len(longest[0]))
    }
}
