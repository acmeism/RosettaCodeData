package main

import (
    "fmt"
    "strconv"
    "strings"
)

func divByAll(num int, digits []byte) bool {
    for _, digit := range digits {
        if num%int(digit-'0') != 0 {
            return false
        }
    }
    return true
}

func main() {
    magic := 9 * 8 * 7
    high := 9876432 / magic * magic
    for i := high; i >= magic; i -= magic {
        if i%10 == 0 {
            continue // can't end in '0'
        }
        s := strconv.Itoa(i)
        if strings.ContainsAny(s, "05") {
            continue // can't contain '0'or '5'
        }
        var set = make(map[byte]bool)
        var sd []byte // distinct digits
        for _, b := range []byte(s) {
            if !set[b] {
                set[b] = true
                sd = append(sd, b)
            }
        }
        if len(sd) != len(s) {
            continue // digits must be unique
        }
        if divByAll(i, sd) {
            fmt.Println("Largest decimal number is", i)
            return
        }
    }
}
