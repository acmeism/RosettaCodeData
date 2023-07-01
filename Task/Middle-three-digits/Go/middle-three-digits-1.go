package m3

import (
    "errors"
    "strconv"
)

var (
    ErrorLT3  = errors.New("N of at least three digits required.")
    ErrorEven = errors.New("N with odd number of digits required.")
)

func Digits(i int) (string, error) {
    if i < 0 {
        i = -i
    }
    if i < 100 {
        return "", ErrorLT3
    }
    s := strconv.Itoa(i)
    if len(s)%2 == 0 {
        return "", ErrorEven
    }
    m := len(s) / 2
    return s[m-1 : m+2], nil
}
