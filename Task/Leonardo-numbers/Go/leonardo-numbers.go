package main

import "fmt"

func leonardo(n, l0, l1, add int) []int {
    leo := make([]int, n)
    leo[0] = l0
    leo[1] = l1
    for i := 2; i < n; i++ {
        leo[i] = leo[i - 1] + leo[i - 2] + add
    }
    return leo
}

func main() {
    fmt.Println("The first 25 Leonardo numbers with L[0] = 1, L[1] = 1 and add number = 1 are:")
    fmt.Println(leonardo(25, 1, 1, 1))
    fmt.Println("\nThe first 25 Leonardo numbers with L[0] = 0, L[1] = 1 and add number = 0 are:")
    fmt.Println(leonardo(25, 0, 1, 0))
}
