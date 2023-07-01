package main

import "fmt"

func countDivisors(n int) int {
    count := 0
    i := 1
    k := 2
    if n%2 == 0 {
        k = 1
    }
    for i*i <= n {
        if n%i == 0 {
            count++
            j := n / i
            if j != i {
                count++
            }
        }
        i += k
    }
    return count
}

func main() {
    fmt.Println("The tau functions for the first 100 positive integers are:")
    for i := 1; i <= 100; i++ {
        fmt.Printf("%2d  ", countDivisors(i))
        if i%20 == 0 {
            fmt.Println()
        }
    }
}
