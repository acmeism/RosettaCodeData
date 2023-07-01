package main

import "fmt"

func pancake(n int) int {
    gap, sum, adj := 2, 2, -1
    for sum < n {
        adj++
        gap = gap*2 - 1
        sum += gap
    }
    return n + adj
}

func main() {
    for i := 0; i < 4; i++ {
        for j := 1; j < 6; j++ {
            n := i*5 + j
            fmt.Printf("p(%2d) = %2d  ", n, pancake(n))
        }
        fmt.Println()
    }
}
