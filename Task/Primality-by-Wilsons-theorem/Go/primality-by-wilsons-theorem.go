package main

import (
    "fmt"
    "math/big"
)

var (
    zero = big.NewInt(0)
    one  = big.NewInt(1)
    prev = big.NewInt(factorial(20))
)

// Only usable for n <= 20.
func factorial(n int64) int64 {
    res := int64(1)
    for k := n; k > 1; k-- {
        res *= k
    }
    return res
}

// If memo == true, stores previous sequential
// factorial calculation for odd n > 21.
func wilson(n int64, memo bool) bool {
    if n <= 1 || (n%2 == 0 && n != 2) {
        return false
    }
    if n <= 21 {
        return (factorial(n-1)+1)%n == 0
    }
    b := big.NewInt(n)
    r := big.NewInt(0)
    z := big.NewInt(0)
    if !memo {
        z.MulRange(2, n-1) // computes factorial from scratch
    } else {
        prev.Mul(prev, r.MulRange(n-2, n-1)) // uses previous calculation
        z.Set(prev)
    }
    z.Add(z, one)
    return r.Rem(z, b).Cmp(zero) == 0
}

func main() {
    numbers := []int64{2, 3, 9, 15, 29, 37, 47, 57, 67, 77, 87, 97, 237, 409, 659}
    fmt.Println("  n  prime")
    fmt.Println("---  -----")
    for _, n := range numbers {
        fmt.Printf("%3d  %t\n", n, wilson(n, false))
    }

    // sequential memoized calculation
    fmt.Println("\nThe first 120 prime numbers are:")
    for i, count := int64(2), 0; count < 1015; i += 2 {
        if wilson(i, true) {
            count++
            if count <= 120 {
                fmt.Printf("%3d ", i)
                if count%20 == 0 {
                    fmt.Println()
                }
            } else if count >= 1000 {
                if count == 1000 {
                    fmt.Println("\nThe 1,000th to 1,015th prime numbers are:")
                }
                fmt.Printf("%4d ", i)
            }
        }
        if i == 2 {
            i--
        }
    }
    fmt.Println()
}
