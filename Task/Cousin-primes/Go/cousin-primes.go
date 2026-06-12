package main

import "fmt"

func isPrime(n int) bool {
    switch {
    case n < 2:
        return false
    case n%2 == 0:
        return n == 2
    case n%3 == 0:
        return n == 3
    default:
        d := 5
        for d*d <= n {
            if n%d == 0 {
                return false
            }
            d += 2
            if n%d == 0 {
                return false
            }
            d += 4
        }
        return true
    }
}

func main() {
    count := 0
    fmt.Println("Cousin prime pairs whose elements are less than 1,000:")
    for i := 3; i <= 995; i += 2 {
        if isPrime(i) && isPrime(i+4) {
            fmt.Printf("%3d:%3d  ", i, i+4)
            count++
            if count%7 == 0 {
                fmt.Println()
            }
            if i != 3 {
                i += 4
            } else {
                i += 2
            }
        }
    }
    fmt.Printf("\n\n%d pairs found\n", count)
}
