package main

import (
    "fmt"
    "strings"
    "unicode/utf8"
)

func checkIsbn13(isbn string) bool {
    // remove any hyphens or spaces
    isbn = strings.ReplaceAll(strings.ReplaceAll(isbn, "-", ""), " ", "")
    // check length == 13
    le := utf8.RuneCountInString(isbn)
    if le != 13 {
        return false
    }
    // check only contains digits and calculate weighted sum
    sum := int32(0)
    for i, c := range isbn {
        if c < '0' || c > '9' {
            return false
        }
        if i%2 == 0 {
            sum += c - '0'
        } else {
            sum += 3 * (c - '0')
        }
    }
    return sum%10 == 0
}

func main() {
    isbns := []string{"978-0596528126", "978-0596528120", "978-1788399081", "978-1788399083"}
    for _, isbn := range isbns {
        res := "bad"
        if checkIsbn13(isbn) {
            res = "good"
        }
        fmt.Printf("%s: %s\n", isbn, res)
    }
}
