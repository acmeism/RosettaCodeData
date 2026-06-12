package main

import (
    "fmt"
    "rcu"
)

func main() {
    pairs := [][2]int{{21, 15}, {17, 23}, {36, 12}, {18, 29}, {60, 15}}
    fmt.Println("The following pairs of numbers are coprime:")
    for _, pair := range pairs {
        if rcu.Gcd(pair[0], pair[1]) == 1 {
            fmt.Println(pair)
        }
    }
}
