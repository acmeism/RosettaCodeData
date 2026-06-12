package main

import (
    "fmt"
    "rcu"
    "strings"
)

func main() {
    var numbers []int
    for n := 0; n < 1000; n++ {
        ns := fmt.Sprintf("%d", n)
        ds := fmt.Sprintf("%d", rcu.DigitSum(n, 10))
        if strings.Contains(ns, ds) {
            numbers = append(numbers, n)
        }
    }
    fmt.Println("Numbers under 1,000 whose sum of digits is a substring of themselves:")
    rcu.PrintTable(numbers, 8, 3, false)
    fmt.Println()
    fmt.Println(len(numbers), "such numbers found.")
}
