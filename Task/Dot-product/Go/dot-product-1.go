package main

import (
    "errors"
    "fmt"
    "log"
)

var (
    v1 = []int{1, 3, -5}
    v2 = []int{4, -2, -1}
)

func dot(x, y []int) (r int, err error) {
    if len(x) != len(y) {
        return 0, errors.New("incompatible lengths")
    }
    for i, xi := range x {
        r += xi * y[i]
    }
    return
}

func main() {
    d, err := dot([]int{1, 3, -5}, []int{4, -2, -1})
    if err != nil {
        log.Fatal(err)
    }
    fmt.Println(d)
}
