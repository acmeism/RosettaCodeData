package main

import (
    "fmt"
    "rcu"
    "strconv"
)

func reverse(s string) string {
    chars := []rune(s)
    for i, j := 0, len(chars)-1; i < j; i, j = i+1, j-1 {
        chars[i], chars[j] = chars[j], chars[i]
    }
    return string(chars)
}

func main() {
    fmt.Println("Numbers under 25,000 in base 10 which are palindromic in bases 2, 4 and 16:")
    var numbers []int
    for i := int64(0); i < 25000; i++ {
        b2 := strconv.FormatInt(i, 2)
        if b2 == reverse(b2) {
            b4 := strconv.FormatInt(i, 4)
            if b4 == reverse(b4) {
                b16 := strconv.FormatInt(i, 16)
                if b16 == reverse(b16) {
                    numbers = append(numbers, int(i))
                }
            }
        }
    }
    for i, n := range numbers {
        fmt.Printf("%6s ", rcu.Commatize(n))
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }
    fmt.Println("\n\nFound", len(numbers), "such numbers.")
}
