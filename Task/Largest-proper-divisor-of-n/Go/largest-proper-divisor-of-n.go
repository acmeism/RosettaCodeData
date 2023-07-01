package main

import "fmt"

func largestProperDivisor(n int) int {
    for i := 2; i*i <= n; i++ {
        if n%i == 0 {
            return n / i
        }
    }
    return 1
}

func main() {
    fmt.Println("The largest proper divisors for numbers in the interval [1, 100] are:")
    fmt.Print(" 1  ")
    for n := 2; n <= 100; n++ {
        if n%2 == 0 {
            fmt.Printf("%2d  ", n/2)
        } else {
            fmt.Printf("%2d  ", largestProperDivisor(n))
        }
        if n%10 == 0 {
            fmt.Println()
        }
    }
}
