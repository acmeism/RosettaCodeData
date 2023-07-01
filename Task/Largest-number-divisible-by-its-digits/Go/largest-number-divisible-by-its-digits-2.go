package main

import (
    "fmt"
    "strconv"
    "strings"
)

func divByAll(num int64, digits []byte) bool {
    for _, digit := range digits {
        var d int64
        if digit <= '9' {
            d = int64(digit - '0')
        } else {
            d = int64(digit - 'W')
        }
        if num%d != 0 {
            return false
        }
    }
    return true
}

func main() {
    var magic int64 = 15 * 14 * 13 * 12 * 11
    high := 0xfedcba987654321 / magic * magic
    for i := high; i >= magic; i -= magic {
        if i%16 == 0 {
            continue // can't end in '0'
        }
        s := strconv.FormatInt(i, 16) // always generates lower case a-f
        if strings.IndexByte(s, '0') >= 0 {
            continue // can't contain '0'
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
            fmt.Printf("Largest hex number is %x\n", i)
            return
        }
    }
}
