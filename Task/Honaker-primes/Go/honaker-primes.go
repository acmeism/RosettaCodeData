package main

import (
    "fmt"
    "rcu"
)

func main() {
    primes := rcu.Primes(5_000_000)
    var h [][2]int
    var h10000 [2]int
    for i, count := 1, 0; count < 10000; i++ {
        if rcu.DigitSum(i, 10) == rcu.DigitSum(primes[i-1], 10) {
            count++
            if count <= 50 {
                h = append(h, [2]int{i, primes[i-1]})
            } else if count == 10000 {
                h10000 = [2]int{i, primes[i-1]}
            }
        }
    }
    fmt.Println("The first 50 Honaker primes (index, prime):\n")
    for i := 0; i < 50; i++ {
        fmt.Printf("(%3d, %5s) ", h[i][0], rcu.Commatize(h[i][1]))
        if (i+1)%5 == 0 {
            fmt.Println()
        }
    }
    fmt.Printf("\nand the 10,000th: (%7s, %9s)\n", rcu.Commatize(h10000[0]), rcu.Commatize(h10000[1]))
}
