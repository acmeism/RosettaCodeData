package main

import (
    "fmt"
    "rcu"
)

func main() {
    p := rcu.Primes(1000)
    fmt.Println("Double twin primes under 1,000:")
    for i := 1; i < len(p)-3; i++ {
        if p[i+1]-p[i] == 2 && p[i+2]-p[i+1] == 4 && p[i+3]-p[i+2] == 2 {
            fmt.Printf("%4d\n", p[i:i+4])
        }
    }
}
