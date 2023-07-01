package main

import (
    "fmt"
    "sort"
    "time"
)

func reverse(s string) string {
    chars := []rune(s)
    for i, j := 0, len(chars)-1; i < j; i, j = i+1, j-1 {
        chars[i], chars[j] = chars[j], chars[i]
    }
    return string(chars)
}

func findIndex(sl []string, s string) int {
    return sort.Search(len(sl), func(i int) bool {
        return sl[i] > s
    })
}

func main() {
    const (
        layout  = "20060102"
        layout2 = "2006-01-02"
    )
    palins := []string{}
    for i := 0; i < 10000; i++ {
        y := fmt.Sprintf("%04d", i)
        r := reverse(y)
        if r[:2] > "12" || r[2:] > "31" {
            continue
        }
        d := fmt.Sprintf("%s%s", y, r)
        t, err := time.Parse(layout, d)
        if err == nil {
            palins = append(palins, t.Format(layout2))
        }
    }
    le := len(palins)
    i1 := findIndex(palins, "1001-01-01")
    i2 := findIndex(palins, "2020-02-02")
    fmt.Printf("There are %d palindromic dates after 0000-01-01 of which:\n", le)
    fmt.Printf("          %d are after 1000-01-01\n", le-i1)
    fmt.Printf("          %d are after 2020-02-02\n", le-i2)
    fmt.Println("\nThe first 15 after 2020-02-02 are:")
    for i := 0; i < 15; i++ {
        if i != 0 && i%5 == 0 {
            fmt.Println()
        }
        fmt.Printf("%s   ", palins[i+i2])
    }
    fmt.Println("\n\nThe last 15 before 9999-12-31 are:")
    for i := 15; i >= 1; i-- {
        if i != 15 && i%5 == 0 {
            fmt.Println()
        }
        fmt.Printf("%s   ", palins[le-i])
    }
    fmt.Println()
}
