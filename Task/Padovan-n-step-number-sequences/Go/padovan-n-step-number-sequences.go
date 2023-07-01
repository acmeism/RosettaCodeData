package main

import "fmt"

func padovanN(n, t int) []int {
    if n < 2 || t < 3 {
        ones := make([]int, t)
        for i := 0; i < t; i++ {
            ones[i] = 1
        }
        return ones
    }
    p := padovanN(n-1, t)
    for i := n + 1; i < t; i++ {
        p[i] = 0
        for j := i - 2; j >= i-n-1; j-- {
            p[i] += p[j]
        }
    }
    return p
}

func main() {
    t := 15
    fmt.Println("First", t, "terms of the Padovan n-step number sequences:")
    for n := 2; n <= 8; n++ {
        fmt.Printf("%d: %3d\n", n, padovanN(n, t))
    }
}
