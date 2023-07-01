package main

import "fmt"

func gcd(n, k int) int {
    if n < k || k < 1 {
        panic("Need n >= k and k >= 1")
    }

    s := 1
    for n&1 == 0 && k&1 == 0 {
        n >>= 1
        k >>= 1
        s <<= 1
    }

    t := n
    if n&1 != 0 {
        t = -k
    }
    for t != 0 {
        for t&1 == 0 {
            t >>= 1
        }
        if t > 0 {
            n = t
        } else {
            k = -t
        }
        t = n - k
    }
    return n * s
}

func totient(n int) int {
    tot := 0
    for k := 1; k <= n; k++ {
        if gcd(n, k) == 1 {
            tot++
        }
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
