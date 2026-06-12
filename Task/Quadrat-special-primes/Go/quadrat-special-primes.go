package main

import (
    "fmt"
    "math"
)

func sieve(limit int) []bool {
    limit++
    // True denotes composite, false denotes prime.
    c := make([]bool, limit) // all false by default
    c[0] = true
    c[1] = true
    // no need to bother with even numbers over 2 for this task
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

func isSquare(n int) bool {
    s := int(math.Sqrt(float64(n)))
    return s*s == n
}

func commas(n int) string {
    s := fmt.Sprintf("%d", n)
    if n < 0 {
        s = s[1:]
    }
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    if n >= 0 {
        return s
    }
    return "-" + s
}

func main() {
    c := sieve(15999)
    fmt.Println("Quadrat special primes under 16,000:")
    fmt.Println(" Prime1  Prime2    Gap  Sqrt")
    lastQuadSpecial := 3
    gap := 1
    count := 1
    fmt.Printf("%7d %7d %6d %4d\n", 2, 3, 1, 1)
    for i := 5; i < 16000; i += 2 {
        if c[i] {
            continue
        }
        gap = i - lastQuadSpecial
        if isSquare(gap) {
            sqrt := int(math.Sqrt(float64(gap)))
            fmt.Printf("%7s %7s %6s %4d\n", commas(lastQuadSpecial), commas(i), commas(gap), sqrt)
            lastQuadSpecial = i
            count++
        }
    }
    fmt.Println("\n", count+1, "such primes found.")
}
