package main

import (
    "fmt"
    "sort"
    "strings"
)

func substrings(s string) []string {
    var ss []string
    n := len(s)
    for i := 0; i < n; i++ {
        for j := 1; j <= n-i; j++ {
            ss = append(ss, s[i:i+j])
        }
    }
    return ss
}

func reversed(s string) string {
    var sb strings.Builder
    for i := len(s) - 1; i >= 0; i-- {
        sb.WriteByte(s[i])
    }
    return sb.String()
}

func main() {
    fmt.Println("Number  Palindromes")
    for i := 100; i <= 125; i++ {
        var pals []string
        ss := substrings(fmt.Sprintf("%d", i))
        for _, s := range ss {
            if s == reversed(s) {
                pals = append(pals, s)
            }
        }
        m := make(map[string]bool)
        for _, pal := range pals {
            m[pal] = true
        }
        pals = pals[:0]
        for k := range m {
            pals = append(pals, k)
        }
        sort.Slice(pals, func(i, j int) bool {
            if len(pals[i]) == len(pals[j]) {
                return pals[i] < pals[j]
            }
            return len(pals[i]) < len(pals[j])
        })
        fmt.Printf("%d   %3s\n", i, pals)
    }
    nums := []string{
        "9", "169", "12769", "1238769", "123498769", "12346098769", "1234572098769",
        "123456832098769", "12345679432098769", "1234567905432098769", "123456790165432098769",
        "83071934127905179083", "1320267947849490361205695",
    }
    fmt.Println("\nNumber                    Has no >= 2 digit palindromes")
    for _, num := range nums {
        tmp := substrings(num)
        var ss []string
        for _, t := range tmp {
            if len(t) > 1 {
                ss = append(ss, t)
            }
        }
        none := true
        for _, s := range ss {
            if s == reversed(s) {
                none = false
                break
            }
        }
        fmt.Printf("%-25s %t\n", num, none)
    }
}
