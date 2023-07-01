package main

import "fmt"

func mertens(to int) ([]int, int, int) {
    if to < 1 {
        to = 1
    }
    merts := make([]int, to+1)
    primes := []int{2}
    var sum, zeros, crosses int
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
                sum++
            } else {
                sum--
            }
        }
        merts[i] = sum
        if sum == 0 {
            zeros++
            if i > 1 && merts[i-1] != 0 {
                crosses++
            }
        }
    }
    return merts, zeros, crosses
}

func main() {
    merts, zeros, crosses := mertens(1000)
    fmt.Println("Mertens sequence - First 199 terms:")
    for i := 0; i < 200; i++ {
        if i == 0 {
            fmt.Print("    ")
            continue
        }
        if i%20 == 0 {
            fmt.Println()
        }
        fmt.Printf("  % d", merts[i])
    }
    fmt.Println("\n\nEquals zero", zeros, "times between 1 and 1000")
    fmt.Println("\nCrosses zero", crosses, "times between 1 and 1000")
}
