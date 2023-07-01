package main

import "fmt"

func countDivisors(n int) int {
    if n < 2 {
        return 1
    }
    count := 2 // 1 and n
    for i := 2; i <= n/2; i++ {
        if n%i == 0 {
            count++
        }
    }
    return count
}

func main() {
    fmt.Println("The first 20 anti-primes are:")
    maxDiv := 0
    count := 0
    for n := 1; count < 20; n++ {
        d := countDivisors(n)
        if d > maxDiv {
            fmt.Printf("%d ", n)
            maxDiv = d
            count++
        }
    }
    fmt.Println()
}
