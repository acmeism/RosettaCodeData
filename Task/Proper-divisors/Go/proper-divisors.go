package main

import (
    "fmt"
    "strconv"
)

func listProperDivisors(limit int) {
    if limit < 1 {
        return
    }
    width := len(strconv.Itoa(limit))
    for i := 1; i <= limit; i++ {
        fmt.Printf("%*d -> ", width, i)
        if i == 1 {
            fmt.Println("(None)")
            continue
        }
        for j := 1; j <= i/2; j++ {
            if i%j == 0 {
                fmt.Printf(" %d", j)
            }
        }
        fmt.Println()
    }
}

func countProperDivisors(n int) int {
    if n < 2 {
        return 0
    }
    count := 0
    for i := 1; i <= n/2; i++ {
        if n%i == 0 {
            count++
        }
    }
    return count
}

func main() {
    fmt.Println("The proper divisors of the following numbers are :\n")
    listProperDivisors(10)
    fmt.Println()
    maxCount := 0
    most := []int{1}
    for n := 2; n <= 20000; n++ {
        count := countProperDivisors(n)
        if count == maxCount {
            most = append(most, n)
        } else if count > maxCount {
            maxCount = count
            most = most[0:1]
            most[0] = n
        }
    }
    fmt.Print("The following number(s) <= 20000 have the most proper divisors, ")
    fmt.Println("namely", maxCount, "\b\n")
    for _, n := range most {
        fmt.Println(n)
    }
}
