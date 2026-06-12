package main

import (
    "fmt"
    "rcu"
    "strconv"
)

func equalSets(s1, s2 map[rune]bool) bool {
    if len(s1) != len(s2) {
        return false
    }
    for k, _ := range s1 {
        _, ok := s2[k]
        if !ok {
            return false
        }
    }
    return true
}

func main() {
    const limit = 100_000
    count := 0
    fmt.Println("Numbers under 100,000 which use the same digits in decimal or hex:")
    for n := 0; n < limit; n++ {
        h := strconv.FormatInt(int64(n), 16)
        hs := make(map[rune]bool)
        for _, c := range h {
            hs[c] = true
        }
        ns := make(map[rune]bool)
        for _, c := range strconv.Itoa(n) {
            ns[c] = true
        }
        if equalSets(hs, ns) {
            count++
            fmt.Printf("%6s ", rcu.Commatize(n))
            if count%10 == 0 {
                fmt.Println()
            }
        }
    }
    fmt.Printf("\n\n%d such numbers found.\n", count)
}
