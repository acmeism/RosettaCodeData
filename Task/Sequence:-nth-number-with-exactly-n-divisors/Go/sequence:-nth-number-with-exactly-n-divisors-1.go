package main

import (
    "fmt"
    "math"
    "math/big"
)

var bi = new(big.Int)

func isPrime(n int) bool {
    bi.SetUint64(uint64(n))
    return bi.ProbablyPrime(0)
}

func generateSmallPrimes(n int) []int {
    primes := make([]int, n)
    primes[0] = 2
    for i, count := 3, 1; count < n; i += 2 {
        if isPrime(i) {
            primes[count] = i
            count++
        }
    }
    return primes
}

func countDivisors(n int) int {
    count := 1
    for n%2 == 0 {
        n >>= 1
        count++
    }
    for d := 3; d*d <= n; d += 2 {
        q, r := n/d, n%d
        if r == 0 {
            dc := 0
            for r == 0 {
                dc += count
                n = q
                q, r = n/d, n%d
            }
            count += dc
        }
    }
    if n != 1 {
        count *= 2
    }
    return count
}

func main() {
    const max = 33
    primes := generateSmallPrimes(max)
    z := new(big.Int)
    p := new(big.Int)
    fmt.Println("The first", max, "terms in the sequence are:")
    for i := 1; i <= max; i++ {
        if isPrime(i) {
            z.SetUint64(uint64(primes[i-1]))
            p.SetUint64(uint64(i - 1))
            z.Exp(z, p, nil)
            fmt.Printf("%2d : %d\n", i, z)
        } else {
            count := 0
            for j := 1; ; j++ {
                if i%2 == 1 {
                    sq := int(math.Sqrt(float64(j)))
                    if sq*sq != j {
                        continue
                    }
                }
                if countDivisors(j) == i {
                    count++
                    if count == i {
                        fmt.Printf("%2d : %d\n", i, j)
                        break
                    }
                }
            }
        }
    }
}
