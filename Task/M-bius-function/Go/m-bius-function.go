package main

import "fmt"

func möbius(to int) []int {
    if to < 1 {
        to = 1
    }
    mobs := make([]int, to+1) // all zero by default
    primes := []int{2}
    for i := 1; i <= to; i++ {
        j := i
        cp := 0      // counts prime factors
        spf := false // true if there is a square prime factor
        for _, p := range primes {
            if p > j {
                break
            }
            if j%p == 0 {
                j /= p
                cp++
            }
            if j%p == 0 {
                spf = true
                break
            }
        }
        if cp == 0 && i > 2 {
            cp = 1
            primes = append(primes, i)
        }
        if !spf {
            if cp%2 == 0 {
                mobs[i] = 1
            } else {
                mobs[i] = -1
            }
        }
    }
    return mobs
}

func main() {
    mobs := möbius(199)
    fmt.Println("Möbius sequence - First 199 terms:")
    for i := 0; i < 200; i++ {
        if i == 0 {
            fmt.Print("    ")
            continue
        }
        if i%20 == 0 {
            fmt.Println()
        }
        fmt.Printf("  % d", mobs[i])
    }
}
