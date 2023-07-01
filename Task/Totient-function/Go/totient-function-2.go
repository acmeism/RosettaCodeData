package main

import "fmt"

func totient(n int) int {
    tot := n
    for i := 2; i*i <= n; i += 2 {
        if n%i == 0 {
            for n%i == 0 {
                n /= i
            }
            tot -= tot / i
        }
        if i == 2 {
            i = 1
        }
    }
    if n > 1 {
        tot -= tot / n
    }
    return tot
}

func main() {
    fmt.Println(" n  phi   prime")
    fmt.Println("---------------")
    count := 0
    for n := 1; n <= 25; n++ {
        tot := totient(n)
        isPrime := n-1 == tot
        if isPrime {
            count++
        }
        fmt.Printf("%2d   %2d   %t\n", n, tot, isPrime)
    }
    fmt.Println("\nNumber of primes up to 25     =", count)
    for n := 26; n <= 100000; n++ {
        tot := totient(n)
        if tot == n-1 {
            count++
        }
        if n == 100 || n == 1000 || n%10000 == 0 {
            fmt.Printf("\nNumber of primes up to %-6d = %d\n", n, count)
        }
    }
}
