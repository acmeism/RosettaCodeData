package main

import (
    "fmt"
    "math"
    "rcu"
)

func main() {
    powers := [10]int{0, 1, 4, 9, 16, 25, 36, 49, 64, 81}
    fmt.Println("Own digits power sums for N = 3 to 9 inclusive:")
    for n := 3; n < 10; n++ {
        for d := 2; d < 10; d++ {
            powers[d] *= d
        }
        i := int(math.Pow(10, float64(n-1)))
        max := i * 10
        lastDigit := 0
        sum := 0
        var digits []int
        for i < max {
            if lastDigit == 0 {
                digits = rcu.Digits(i, 10)
                sum = 0
                for _, d := range digits {
                    sum += powers[d]
                }
            } else if lastDigit == 1 {
                sum++
            } else {
                sum += powers[lastDigit] - powers[lastDigit-1]
            }
            if sum == i {
                fmt.Println(i)
                if lastDigit == 0 {
                    fmt.Println(i + 1)
                }
                i += 10 - lastDigit
                lastDigit = 0
            } else if sum > i {
                i += 10 - lastDigit
                lastDigit = 0
            } else if lastDigit < 9 {
                i++
                lastDigit++
            } else {
                i++
                lastDigit = 0
            }
        }
    }
}
