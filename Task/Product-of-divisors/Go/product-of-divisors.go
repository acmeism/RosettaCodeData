package main

import "fmt"

func prodDivisors(n int) int {
    prod := 1
    i := 1
    k := 2
    if n%2 == 0 {
        k = 1
    }
    for i*i <= n {
        if n%i == 0 {
            prod *= i
            j := n / i
            if j != i {
                prod *= j
            }
        }
        i += k
    }
    return prod
}

func main() {
    fmt.Println("The products of positive divisors for the first 50 positive integers are:")
    for i := 1; i <= 50; i++ {
        fmt.Printf("%9d  ", prodDivisors(i))
        if i%5 == 0 {
            fmt.Println()
        }
    }
}
