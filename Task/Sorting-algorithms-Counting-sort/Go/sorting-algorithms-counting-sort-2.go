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

    // WP algorithm
    k := aMax - aMin // k is maximum key value. keys range 0..k
    count := make([]int, k+1)
    key := func(v int) int { return v - aMin }
    for _, x := range a {
        count[key(x)]++
    }
    total := 0
    for i, c := range count {
        count[i] = total
        total += c
    }
    output := make([]int, len(a))
    for _, x := range a {
        output[count[key(x)]] = x
        count[key(x)]++
    }
    copy(a, output)
}
