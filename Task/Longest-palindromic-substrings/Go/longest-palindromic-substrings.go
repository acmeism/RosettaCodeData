package main

import (
    "fmt"
    "sort"
)

func reverse(s string) string {
    var r = []rune(s)
    for i, j := 0, len(r)-1; i < j; i, j = i+1, j-1 {
        r[i], r[j] = r[j], r[i]
    }
    return string(r)
}

func longestPalSubstring(s string) []string {
    var le = len(s)
    if le <= 1 {
        return []string{s}
    }
    targetLen := le
    var longest []string
    i := 0
    for {
        j := i + targetLen - 1
        if j < le {
            ss := s[i : j+1]
            if reverse(ss) == ss {
                longest = append(longest, ss)
            }
            i++
        } else {
            if len(longest) > 0 {
                return longest
            }
            i = 0
            targetLen--
        }
    }
    return longest
}

func distinct(sa []string) []string {
    sort.Strings(sa)
    duplicated := make([]bool, len(sa))
    for i := 1; i < len(sa); i++ {
        if sa[i] == sa[i-1] {
            duplicated[i] = true
        }
    }
    var res []string
    for i := 0; i < len(sa); i++ {
        if !duplicated[i] {
            res = append(res, sa[i])
        }
    }
    return res
}

func main() {
    strings := []string{"babaccd", "rotator", "reverse", "forever", "several", "palindrome", "abaracadaraba"}
    fmt.Println("The palindromic substrings having the longest length are:")
    for _, s := range strings {
        longest := distinct(longestPalSubstring(s))
        fmt.Printf("  %-13s Length %d -> %v\n", s, len(longest[0]), longest)
    }
}
