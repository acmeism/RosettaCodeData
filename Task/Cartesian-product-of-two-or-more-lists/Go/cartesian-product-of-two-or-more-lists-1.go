package main

import "fmt"

type pair [2]int

func cart2(a, b []int) []pair {
    p := make([]pair, len(a)*len(b))
    i := 0
    for _, a := range a {
        for _, b := range b {
            p[i] = pair{a, b}
            i++
        }
    }
    return p
}

func main() {
    fmt.Println(cart2([]int{1, 2}, []int{3, 4}))
    fmt.Println(cart2([]int{3, 4}, []int{1, 2}))
    fmt.Println(cart2([]int{1, 2}, nil))
    fmt.Println(cart2(nil, []int{1, 2}))
}
