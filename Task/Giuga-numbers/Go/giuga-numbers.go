package main

import "fmt"

var factors []int
var inc = []int{4, 2, 4, 2, 4, 6, 2, 6}

// Assumes n is even with exactly one factor of 2.
// Empties 'factors' if any other prime factor is repeated.
func primeFactors(n int) {
    factors = factors[:0]
    factors = append(factors, 2)
    last := 2
    n /= 2
    for n%3 == 0 {
        if last == 3 {
            factors = factors[:0]
            return
        }
        last = 3
        factors = append(factors, 3)
        n /= 3
    }
    for n%5 == 0 {
        if last == 5 {
            factors = factors[:0]
            return
        }
        last = 5
        factors = append(factors, 5)
        n /= 5
    }
    for k, i := 7, 0; k*k <= n; {
        if n%k == 0 {
            if last == k {
                factors = factors[:0]
                return
            }
            last = k
            factors = append(factors, k)
            n /= k
        } else {
            k += inc[i]
            i = (i + 1) % 8
        }
    }
    if n > 1 {
        factors = append(factors, n)
    }
}

func main() {
    const limit = 5
    var giuga []int
    // n can't be 2 or divisible by 4
    for n := 6; len(giuga) < limit; n += 4 {
        primeFactors(n)
        // can't be prime or semi-prime
        if len(factors) > 2 {
            isGiuga := true
            for _, f := range factors {
                if (n/f-1)%f != 0 {
                    isGiuga = false
                    break
                }
            }
            if isGiuga {
                giuga = append(giuga, n)
            }
        }
    }
    fmt.Println("The first", limit, "Giuga numbers are:")
    fmt.Println(giuga)
}
