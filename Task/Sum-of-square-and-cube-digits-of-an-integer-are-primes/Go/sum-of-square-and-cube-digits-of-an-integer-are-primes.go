package main

import (
    "fmt"
    "rcu"
)

func main() {
    for i := 1; i < 100; i++ {
        if !rcu.IsPrime(rcu.DigitSum(i*i, 10)) {
            continue
        }
        if rcu.IsPrime(rcu.DigitSum(i*i*i, 10)) {
            fmt.Printf("%d ", i)
        }
    }
    fmt.Println()
}
