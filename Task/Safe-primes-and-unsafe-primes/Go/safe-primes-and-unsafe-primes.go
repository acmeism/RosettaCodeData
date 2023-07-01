package main

import "fmt"

func sieve(limit uint64) []bool {
    limit++
    // True denotes composite, false denotes prime.
    c := make([]bool, limit) // all false by default
    c[0] = true
    c[1] = true
    // apart from 2 all even numbers are of course composite
    for i := uint64(4); i < limit; i += 2 {
        c[i] = true
    }
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
    // sieve up to 10 million
    sieved := sieve(1e7)
    var safe = make([]int, 35)
    count := 0
    for i := 3; count < 35; i += 2 {
        if !sieved[i] && !sieved[(i-1)/2] {
            safe[count] = i
            count++
        }
    }
    fmt.Println("The first 35 safe primes are:\n", safe, "\n")

    count = 0
    for i := 3; i < 1e6; i += 2 {
        if !sieved[i] && !sieved[(i-1)/2] {
            count++
        }
    }
    fmt.Println("The number of safe primes below 1,000,000 is", commatize(count), "\n")

    for i := 1000001; i < 1e7; i += 2 {
        if !sieved[i] && !sieved[(i-1)/2] {
            count++
        }
    }
    fmt.Println("The number of safe primes below 10,000,000 is", commatize(count), "\n")

    unsafe := make([]int, 40)
    unsafe[0] = 2 // since (2 - 1)/2 is not prime
    count = 1
    for i := 3; count < 40; i += 2 {
        if !sieved[i] && sieved[(i-1)/2] {
            unsafe[count] = i
            count++
        }
    }
    fmt.Println("The first 40 unsafe primes are:\n", unsafe, "\n")

    count = 1
    for i := 3; i < 1e6; i += 2 {
        if !sieved[i] && sieved[(i-1)/2] {
            count++
        }
    }
    fmt.Println("The number of unsafe primes below 1,000,000 is", commatize(count), "\n")

    for i := 1000001; i < 1e7; i += 2 {
        if !sieved[i] && sieved[(i-1)/2] {
            count++
        }
    }
    fmt.Println("The number of unsafe primes below 10,000,000 is", commatize(count), "\n")
}
