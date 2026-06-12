package main

import (
    "fmt"
    "rcu"
)

func main() {
    var sgp []int
    p := 2
    count := 0
    for count < 50 {
        if rcu.IsPrime(p) && rcu.IsPrime(2*p+1) {
            sgp = append(sgp, p)
            count++
        }
        if p != 2 {
            p = p + 2
        } else {
            p = 3
        }
    }
    fmt.Println("The first 50 Sophie Germain primes are:")
    for i := 0; i < len(sgp); i++ {
        fmt.Printf("%5s ", rcu.Commatize(sgp[i]))
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }
}
