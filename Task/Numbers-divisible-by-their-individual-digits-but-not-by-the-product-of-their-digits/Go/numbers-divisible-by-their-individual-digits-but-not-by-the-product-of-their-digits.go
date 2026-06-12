package main

import (
    "fmt"
    "rcu"
)

func main() {
    var res []int
    for n := 1; n < 1000; n++ {
        digits := rcu.Digits(n, 10)
        var all = true
        for _, d := range digits {
            if d == 0 || n%d != 0 {
                all = false
                break
            }
        }
        if all {
            prod := 1
            for _, d := range digits {
                prod *= d
            }
            if prod > 0 && n%prod != 0 {
                res = append(res, n)
            }
        }
    }
    fmt.Println("Numbers < 1000 divisible by their digits, but not by the product thereof:")
    for i, n := range res {
        fmt.Printf("%4d", n)
        if (i+1)%9 == 0 {
            fmt.Println()
        }
    }
    fmt.Printf("\n%d such numbers found\n", len(res))
}
