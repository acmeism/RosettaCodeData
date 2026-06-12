package main

import (
    "fmt"
    "log"
    "math"
    "strings"
)

var error = "Argument must be a numeric literal or a decimal numeric string."

func getNumDecimals(n interface{}) int {
    switch v := n.(type) {
    case int:
        return 0
    case float64:
        if v == math.Trunc(v) {
            return 0
        }
        s := fmt.Sprintf("%g", v)
        return len(strings.Split(s, ".")[1])
    case string:
        if v == "" {
            log.Fatal(error)
        }
        if v[0] == '+' || v[0] == '-' {
            v = v[1:]
        }
        for _, c := range v {
            if strings.IndexRune("0123456789.", c) == -1 {
                log.Fatal(error)
            }
        }
        s := strings.Split(v, ".")
        ls := len(s)
        if ls == 1 {
            return 0
        } else if ls == 2 {
            return len(s[1])
        } else {
            log.Fatal("Too many decimal points")
        }
    default:
        log.Fatal(error)
    }
    return 0
}

func main() {
    var a = []interface{}{12, 12.345, 12.345555555555, "12.3450", "12.34555555555555555555", 12.345e53}
    for _, n := range a {
        d := getNumDecimals(n)
        switch v := n.(type) {
        case string:
            fmt.Printf("%q has %d decimals\n", v, d)
        case float32, float64:
            fmt.Printf("%g has %d decimals\n", v, d)
        default:
            fmt.Printf("%d has %d decimals\n", v, d)
        }
    }
}
