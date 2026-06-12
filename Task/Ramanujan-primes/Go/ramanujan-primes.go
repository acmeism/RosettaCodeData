package main

import (
    "fmt"
    "math"
    "rcu"
    "time"
)

var count []int

func primeCounter(limit int) {
    count = make([]int, limit)
    for i := 0; i < limit; i++ {
        count[i] = 1
    }
    if limit > 0 {
        count[0] = 0
    }
    if limit > 1 {
        count[1] = 0
    }
    for i := 4; i < limit; i += 2 {
        count[i] = 0
    }
    for p, sq := 3, 9; sq < limit; p += 2 {
        if count[p] != 0 {
            for q := sq; q < limit; q += p << 1 {
                count[q] = 0
            }
        }
        sq += (p + 1) << 2
    }
    sum := 0
    for i := 0; i < limit; i++ {
        sum += count[i]
        count[i] = sum
    }
}

func primeCount(n int) int {
    if n < 1 {
        return 0
    }
    return count[n]
}

func ramanujanMax(n int) int {
    fn := float64(n)
    return int(math.Ceil(4 * fn * math.Log(4*fn)))
}

func ramanujanPrime(n int) int {
    if n == 1 {
        return 2
    }
    for i := ramanujanMax(n); i >= 2*n; i-- {
        if i%2 == 1 {
            continue
        }
        if primeCount(i)-primeCount(i/2) < n {
            return i + 1
        }
    }
    return 0
}

func main() {
    start := time.Now()
    primeCounter(1 + ramanujanMax(1e6))
    fmt.Println("The first 100 Ramanujan primes are:")
    rams := make([]int, 100)
    for n := 0; n < 100; n++ {
        rams[n] = ramanujanPrime(n + 1)
    }
    for i, r := range rams {
        fmt.Printf("%5s ", rcu.Commatize(r))
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }

    fmt.Printf("\nThe 1,000th Ramanujan prime is %6s\n", rcu.Commatize(ramanujanPrime(1000)))

    fmt.Printf("\nThe 10,000th Ramanujan prime is %7s\n", rcu.Commatize(ramanujanPrime(10000)))

    fmt.Printf("\nThe 100,000th Ramanujan prime is %6s\n", rcu.Commatize(ramanujanPrime(100000)))

    fmt.Printf("\nThe 1,000,000th Ramanujan prime is %7s\n", rcu.Commatize(ramanujanPrime(1000000)))

    fmt.Println("\nTook", time.Since(start))
}
