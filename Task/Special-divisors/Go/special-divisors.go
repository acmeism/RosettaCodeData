package main

import (
    "fmt"
    "rcu"
)

func reversed(n int) int {
    rev := 0
    for n > 0 {
        rev = rev*10 + n%10
        n = n / 10
    }
    return rev
}

func main() {
    var special []int
    for n := 1; n < 200; n++ {
        divs := rcu.Divisors(n)
        revN := reversed(n)
        all := true
        for _, d := range divs {
            if revN%reversed(d) != 0 {
                all = false
                break
            }
        }
        if all {
            special = append(special, n)
        }
    }
    fmt.Println("Special divisors in the range 0..199:")
    for i, n := range special {
        fmt.Printf("%3d ", n)
        if (i+1)%12 == 0 {
            fmt.Println()
        }
    }
    fmt.Printf("\n%d special divisors found.\n", len(special))
}
