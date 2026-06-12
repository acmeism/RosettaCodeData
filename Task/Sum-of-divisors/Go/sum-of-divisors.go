package main

import "fmt"

func sumDivisors(n int) int {
    sum := 0
    i := 1
    k := 2
    if n%2 == 0 {
        k = 1
    }
    for i*i <= n {
        if n%i == 0 {
            sum += i
            j := n / i
            if j != i {
                sum += j
            }
        }
        i += k
    }
    return sum
}

func main() {
    fmt.Println("The sums of positive divisors for the first 100 positive integers are:")
    for i := 1; i <= 100; i++ {
        fmt.Printf("%3d   ", sumDivisors(i))
        if i%10 == 0 {
            fmt.Println()
        }
    }
}
