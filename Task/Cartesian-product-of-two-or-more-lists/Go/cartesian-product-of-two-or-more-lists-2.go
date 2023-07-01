package main

import "fmt"

func cartN(a ...[]int) [][]int {
    c := 1
    for _, a := range a {
        c *= len(a)
    }
    if c == 0 {
        return nil
    }
    p := make([][]int, c)
    b := make([]int, c*len(a))
    n := make([]int, len(a))
    s := 0
    for i := range p {
        e := s + len(a)
        pi := b[s:e]
        p[i] = pi
        s = e
        for j, n := range n {
            pi[j] = a[j][n]
        }
        for j := len(n) - 1; j >= 0; j-- {
            n[j]++
            if n[j] < len(a[j]) {
                break
            }
            n[j] = 0
        }
    }
    return p
}

func main() {
    fmt.Println(cartN([]int{1, 2}, []int{3, 4}))
    fmt.Println(cartN([]int{3, 4}, []int{1, 2}))
    fmt.Println(cartN([]int{1, 2}, nil))
    fmt.Println(cartN(nil, []int{1, 2}))

    fmt.Println()
    fmt.Println("[")
    for _, p := range cartN(
        []int{1776, 1789},
        []int{7, 12},
        []int{4, 14, 23},
        []int{0, 1},
    ) {
        fmt.Println(" ", p)
    }
    fmt.Println("]")
    fmt.Println(cartN([]int{1, 2, 3}, []int{30}, []int{500, 100}))
    fmt.Println(cartN([]int{1, 2, 3}, []int{}, []int{500, 100}))

    fmt.Println()
    fmt.Println(cartN(nil))
    fmt.Println(cartN())
}
