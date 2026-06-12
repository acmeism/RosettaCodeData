package main

import "fmt"

func sieve(limit int) []bool {
    limit++
    // True denotes composite, false denotes prime.
    c := make([]bool, limit) // all false by default
    c[0] = true
    c[1] = true
    for i := 4; i < limit; i += 2 {
        c[i] = true
    }
    p := 3 // Start from 3.
    for {
        p2 := p * p
        if p2 >= limit {
            break
        }
        for i := p2; i < limit; i += 2 * p {
            c[i] = true
        }
        for {
            p += 2
            if !c[p] {
                break
            }
        }
    }
    return c
}

func reversed(n int) int {
    rev := 0
    for n > 0 {
        rev = rev*10 + n%10
        n /= 10
    }
    return rev
}

func main() {
    c := sieve(999)
    reversedPrimes := []int{2}
    for i := 3; i < 500; i += 2 {
        if !c[i] && !c[reversed(i)] {
            reversedPrimes = append(reversedPrimes, i)
        }
    }
    fmt.Println("Primes under 500 which are also primes when the digits are reversed:")
    for i, p := range reversedPrimes {
        fmt.Printf("%5d", p)
        if (i+1) % 10 == 0 {
            fmt.Println()
        }
    }
    fmt.Printf("\n\n%d such primes found.\n", len(reversedPrimes))
}
