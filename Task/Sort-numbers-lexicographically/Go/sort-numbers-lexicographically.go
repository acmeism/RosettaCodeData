package main

import (
    "fmt"
    "sort"
    "strconv"
)

func lexOrder(n int) []int {
    first, last, k := 1, n, n
    if n < 1 {
        first, last, k = n, 1, 2-n
    }
    strs := make([]string, k)
    for i := first; i <= last; i++ {
        strs[i-first] = strconv.Itoa(i)
    }
    sort.Strings(strs)
    ints := make([]int, k)
    for i := 0; i < k; i++ {
        ints[i], _ = strconv.Atoi(strs[i])
    }
    return ints
}

func main() {
    fmt.Println("In lexicographical order:\n")
    for _, n := range []int{0, 5, 13, 21, -22} {
        fmt.Printf("%3d: %v\n", n, lexOrder(n))
    }
}
