package main

import "fmt"

func sieve(limit uint64) []bool {
    limit++
    // True denotes composite, false denotes prime.
    c := make([]bool, limit) // all false by default
    c[0] = true
    c[1] = true
    // no need to bother with even numbers over 2 for this task
    p := uint64(3) // Start from 3.
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
    c := sieve(1e10 - 1)
    limit := 10
    start := 3
    twins := 0
    for i := 1; i < 11; i++ {
        for i := start; i < limit; i += 2 {
            if !c[i] && !c[i-2] {
                twins++
            }
        }
        fmt.Printf("Under %14s there are %10s pairs of twin primes.\n", commatize(limit), commatize(twins))
        start = limit + 1
        limit *= 10
    }
}
