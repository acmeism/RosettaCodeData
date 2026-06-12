package main

import (
    "fmt"
    "math"
    "rcu"
)

func main() {
    limit := int(math.Log(1e7) * 1e7 * 1.2) // should be more than enough
    primes := rcu.Primes(limit)
    fmt.Println("The first 20 pairs of natural numbers whose sum is prime are:")
    for i := 1; i <= 20; i++ {
        p := primes[i]
        hp := p / 2
        fmt.Printf("%2d + %2d = %2d\n", hp, hp+1, p)
    }
    fmt.Println("\nThe 10 millionth such pair is:")
    p := primes[1e7]
    hp := p / 2
    fmt.Printf("%2d + %2d = %2d\n", hp, hp+1, p)
}
