package main

import (
    "fmt"
    "rcu"
)

func main() {
    var numbers []int
    for i := 2; i < 200; i++ {
        bds := rcu.DigitSum(i, 2)
        if rcu.IsPrime(bds) {
            tds := rcu.DigitSum(i, 3)
            if rcu.IsPrime(tds) {
                numbers = append(numbers, i)
            }
        }
    }
    fmt.Println("Numbers < 200 whose binary and ternary digit sums are prime:")
    for i, n := range numbers {
        fmt.Printf("%4d", n)
        if (i+1)%14 == 0 {
            fmt.Println()
        }
    }
    fmt.Printf("\n\n%d such numbers found\n", len(numbers))
}
