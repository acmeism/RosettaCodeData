package main

import (
    "fmt"
    "rcu"
)

func main() {
    fmt.Println("Decimal numbers under 1,000 whose digits include two 1's:")
    var results []int
    for i := 11; i <= 911; i++ {
        digits := rcu.Digits(i, 10)
        count := 0
        for _, d := range digits {
            if d == 1 {
                count++
            }
        }
        if count == 2 {
            results = append(results, i)
        }
    }
    for i, n := range results {
        fmt.Printf("%5d", n)
        if (i+1)%7 == 0 {
            fmt.Println()
        }
    }
    fmt.Println("\n\nFound", len(results), "such numbers.")
}
