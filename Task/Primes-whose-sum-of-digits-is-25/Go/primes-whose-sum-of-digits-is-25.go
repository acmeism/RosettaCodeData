package main

import (
    "fmt"
    big "github.com/ncw/gmp"
    "time"
)

// for small numbers
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

func sumDigits(n int) int {
    sum := 0
    for n > 0 {
        sum += n % 10
        n /= 10
    }
    return sum
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

// for big numbers
func countAll(p string, rem, res int) int {
    if rem == 0 {
        b := p[len(p)-1]
        if b == '1' || b == '3' || b == '7' || b == '9' {
            z := new(big.Int)
            z.SetString(p, 10)
            if z.ProbablyPrime(1) {
                res++
            }
        }
    } else {
        for i := 1; i <= min(9, rem); i++ {
            res = countAll(p+fmt.Sprintf("%d", i), rem-i, res)
        }
    }
    return res
}

func commatize(n int) string {
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
    start := time.Now()
    c := sieve(4999)
    var primes25 []int
    for i := 997; i < 5000; i += 2 {
        if !c[i] && sumDigits(i) == 25 {
            primes25 = append(primes25, i)
        }
    }
    fmt.Println("The", len(primes25), "primes under 5,000 whose digits sum to 25 are:")
    fmt.Println(primes25)
    n := countAll("", 25, 0)
    fmt.Println("\nThere are", commatize(n), "primes whose digits sum to 25 and include no zeros.")
    fmt.Printf("\nTook %s\n", time.Since(start))
}
