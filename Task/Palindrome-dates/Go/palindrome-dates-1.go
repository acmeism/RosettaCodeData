package main

import (
    "fmt"
    "time"
)

func reverse(s string) string {
    chars := []rune(s)
    for i, j := 0, len(chars)-1; i < j; i, j = i+1, j-1 {
        chars[i], chars[j] = chars[j], chars[i]
    }
    return string(chars)
}

func main() {
    const (
        layout  = "20060102"
        layout2 = "2006-01-02"
    )
    fmt.Println("The next 15 palindromic dates in yyyymmdd format after 20200202 are:")
    date := time.Date(2020, 2, 2, 0, 0, 0, 0, time.UTC)
    count := 0
    for count < 15 {
        date = date.AddDate(0, 0, 1)
        s := date.Format(layout)
        r := reverse(s)
        if r == s {
            fmt.Println(date.Format(layout2))
            count++
        }
    }
}
