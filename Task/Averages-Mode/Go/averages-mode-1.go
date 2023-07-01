package main

import "fmt"

func main() {
    fmt.Println(mode([]int{2, 7, 1, 8, 2}))
    fmt.Println(mode([]int{2, 7, 1, 8, 2, 8}))
}

func mode(a []int) []int {
    m := make(map[int]int)
    for _, v := range a {
        m[v]++
    }
    var mode []int
    var n int
    for k, v := range m {
        switch {
        case v < n:
        case v > n:
            n = v
            mode = append(mode[:0], k)
        default:
            mode = append(mode, k)
        }
    }
    return mode
}
