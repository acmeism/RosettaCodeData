package main

import (
    "fmt"
    "rcu"
)

func main() {
    fmt.Println("Cumulative sums of the first 50 cubes:")
    sum := 0
    for n := 0; n < 50; n++ {
        sum += n * n * n
        fmt.Printf("%9s ", rcu.Commatize(sum))
        if n%10 == 9 {
            fmt.Println()
        }
    }
    fmt.Println()
