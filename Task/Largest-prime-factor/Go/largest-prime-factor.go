package main

import "fmt"

func largestPrimeFactor(n uint64) uint64 {
    if n < 2 {
        return 1
    }
    inc := [8]uint64{4, 2, 4, 2, 4, 6, 2, 6}
    max := uint64(1)
    for n%2 == 0 {
        max = 2
        n /= 2
    }
    for n%3 == 0 {
        max = 3
        n /= 3
    }
    for n%5 == 0 {
        max = 5
        n /= 5
    }
    k := uint64(7)
    i := 0
    for k*k <= n {
        if n%k == 0 {
            max = k
            n /= k
        } else {
            k += inc[i]
            i = (i + 1) % 8
        }
    }
    if n > 1 {
        return n
    }
    return max
}

func main() {
    n := uint64(600851475143)
    fmt.Println("The largest prime factor of", n, "is", largestPrimeFactor(n), "\b.")
}
