package main

import (
    "fmt"
    "math"
    "rcu"
)

func pi(n int) int {
    if n < 2 {
        return 0
    }
    if n == 2 {
        return 1
    }
    primes := rcu.Primes(int(math.Sqrt(float64(n))))
    a := len(primes)

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
        return phi(x, a-1) - phi(x/pa, a-1)
    }

    return phi(n, a) + a - 1
}

func main() {
    for i, n := 0, 1; i <= 9; i, n = i+1, n*10 {
        fmt.Printf("10^%d  %d\n", i, pi(n))
    }
}
