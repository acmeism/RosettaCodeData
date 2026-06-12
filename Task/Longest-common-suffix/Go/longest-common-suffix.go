package main

import (
    "fmt"
    "strings"
)

func lcs(a []string) string {
    le := len(a)
    if le == 0 {
        return ""
    }
    if le == 1 {
        return a[0]
    }
    le0 := len(a[0])
    minLen := le0
    for i := 1; i < le; i++ {
        if len(a[i]) < minLen {
            minLen = len(a[i])
        }
    }
    if minLen == 0 {
        return ""
    }
    res := ""
    a1 := a[1:]
    for i := 1; i <= minLen; i++ {
        suffix := a[0][le0-i:]
        for _, e := range a1 {
            if !strings.HasSuffix(e, suffix) {
                return res
            }
        }
        res = suffix
    }
    return res
}

func main() {
    tests := [][]string{
        {"baabababc", "baabc", "bbbabc"},
        {"baabababc", "baabc", "bbbazc"},
        {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"},
        {"longest", "common", "suffix"},
        {"suffix"},
        {""},
    }
    for _, test := range tests {
        fmt.Printf("%v -> \"%s\"\n", test, lcs(test))
    }
}
