package main

import (
    "fmt"
    "rcu"
)

func main() {
    // cache 5th powers of digits
    dp5 := [10]int{0, 1}
    for i := 2; i < 10; i++ {
        ii := i * i
        dp5[i] = ii * ii * i
    }
    fmt.Println("The sum of all numbers that can be written as the sum of the 5th powers of their digits is:")
    limit := dp5[9] * 6
    sum := 0
    for i := 2; i <= limit; i++ {
        digits := rcu.Digits(i, 10)
        totalDp := 0
        for _, d := range digits {
            totalDp += dp5[d]
        }
        if totalDp == i {
            if sum > 0 {
                fmt.Printf(" + %d", i)
            } else {
                fmt.Print(i)
            }
            sum += i
        }
    }
    fmt.Printf(" = %d\n", sum)
}
