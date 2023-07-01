package main

import (
    "fmt"
    "log"
    "math"
    "rcu"
)

func cantorPair(x, y int) int {
    if x < 0 || y < 0 {
        log.Fatal("Arguments must be non-negative integers.")
    }
    return (x*x + 3*x + 2*x*y + y + y*y) / 2
}

func pi(n int) int {
    if n < 2 {
        return 0
    }
    if n == 2 {
        return 1
    }
    primes := rcu.Primes(int(math.Sqrt(float64(n))))
    a := len(primes)
    memoPhi := make(map[int]int)

    var phi func(x, a int) int // recursive closure
    phi = func(x, a int) int {
        if a < 1 {
            return x
        }
        if a == 1 {
            return x - (x >> 1)
        }
        pa := primes[a-1]
        if x <= pa {
            return 1
        }
        key := cantorPair(x, a)
        if v, ok := memoPhi[key]; ok {
            return v
        }
        memoPhi[key] = phi(x, a-1) - phi(x/pa, a-1)
        return memoPhi[key]
    }

    return phi(n, a) + a - 1
}

func main() {
    for i, n := 0, 1; i <= 9; i, n = i+1, n*10 {
        fmt.Printf("10^%d  %d\n", i, pi(n))
    }
}
