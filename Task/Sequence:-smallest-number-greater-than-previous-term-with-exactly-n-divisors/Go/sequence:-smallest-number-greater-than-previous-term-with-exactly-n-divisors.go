package main

import "fmt"

func countDivisors(n int) int {
    count := 0
    for i := 1; i*i <= n; i++ {
        if n%i == 0 {
            if i == n/i {
                count++
            } else {
                count += 2
            }
        }
    }
    return count
}

func main() {
    const max = 15
    fmt.Println("The first", max, "terms of the sequence are:")
    for i, next := 1, 1; next <= max; i++ {
        if next == countDivisors(i) {
            fmt.Printf("%d ", i)
            next++
        }
    }
    fmt.Println()
}
