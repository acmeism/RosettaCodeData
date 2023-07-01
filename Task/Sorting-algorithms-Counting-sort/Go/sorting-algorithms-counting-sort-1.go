package main

import (
    "fmt"
    "runtime"
    "strings"
)

var a = []int{170, 45, 75, -90, -802, 24, 2, 66}
var aMin, aMax = -1000, 1000

func main() {
    fmt.Println("before:", a)
    countingSort(a, aMin, aMax)
    fmt.Println("after: ", a)
}

func countingSort(a []int, aMin, aMax int) {
    defer func() {
        if x := recover(); x != nil {
            // one error we'll handle and print a little nicer message
            if _, ok := x.(runtime.Error); ok &&
                strings.HasSuffix(x.(error).Error(), "index out of range") {
                fmt.Printf("data value out of range (%d..%d)\n", aMin, aMax)
                return
            }
            // anything else, we re-panic
            panic(x)
        }
    }()

    count := make([]int, aMax-aMin+1)
    for _, x := range a {
        count[x-aMin]++
    }
    z := 0
    // optimization over task pseudocode:   variable c is used instead of
    // count[i-min].  This saves some unneccessary calculations.
    for i, c := range count {
        for ; c > 0; c-- {
            a[z] = i + aMin
            z++
        }
    }
}
