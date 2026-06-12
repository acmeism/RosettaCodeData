package main

import (
    "fmt"
    "rcu"
    "strconv"
    "strings"
)

func reverse(s string) string {
    chars := []rune(s)
    for i, j := 0, len(chars)-1; i < j; i, j = i+1, j-1 {
        chars[i], chars[j] = chars[j], chars[i]
    }
    return string(chars)
}

func main() {
    fmt.Println("Primes < 500 which are palindromic in base 16:")
    primes := rcu.Primes(500)
    count := 0
    for _, p := range primes {
        hp := strconv.FormatInt(int64(p), 16)
        if hp == reverse(hp) {
            fmt.Printf("%3s ", strings.ToUpper(hp))
            count++
            if count%5 == 0 {
                fmt.Println()
            }
        }
    }
    fmt.Println("\n\nFound", count, "such primes.")
}
