package main

import "fmt"

// Use this rather than % for negative integers
func mod(n, m int) int {
    return ((n % m) + m) % m
}

func isPrime(n int) bool {
    if n < 2 { return false }
    if n % 2 == 0 { return n == 2 }
    if n % 3 == 0 { return n == 3 }
    d := 5
    for d * d <= n {
        if n % d == 0 { return false }
        d += 2
        if n % d == 0 { return false }
        d += 4
    }
    return true
}

func carmichael(p1 int) {
    for h3 := 2; h3 < p1; h3++ {
        for d := 1; d < h3 + p1; d++ {
            if (h3 + p1) * (p1 - 1) % d == 0 && mod(-p1 * p1, h3) == d % h3 {
                p2 := 1 + (p1 - 1) * (h3 + p1) / d
                if !isPrime(p2) { continue }
                p3 := 1 + p1 * p2 / h3
                if !isPrime(p3) { continue }
                if p2 * p3 % (p1 - 1) != 1 { continue }
                c := p1 * p2 * p3
                fmt.Printf("%2d   %4d   %5d     %d\n", p1, p2, p3, c)
            }
        }
    }
}

func main() {
    fmt.Println("The following are Carmichael munbers for p1 <= 61:\n")
    fmt.Println("p1     p2      p3     product")
    fmt.Println("==     ==      ==     =======")

    for p1 := 2; p1 <= 61; p1++ {
        if isPrime(p1) { carmichael(p1) }
    }
}
