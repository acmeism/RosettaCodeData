package main

import (
    "fmt"
    "math/big"
    "rcu"
    "time"
)

var start = time.Now()

const max = 50_000_000

var primes = rcu.Primes(max)

func calmoPrimes(limit int) (int, []int, []int, []int) {
    var pc, sum int
    if limit < max {
        for i := 0; i < len(primes); i++ {
            if primes[i] > limit {
                pc = i
                break
            }
        }
    } else {
        pc = len(primes)
    }
    for i := 0; i < pc; i++ {
        sum += primes[i]
    }
    longest := 0
    var sIndices, eIndices, sums []int
    for i := 0; i < pc; i++ {
        if pc-i < longest {
            break
        }
        if i > 0 {
            sum -= primes[i-1]
        }
        isEven := i == 0
        sum2 := sum
        for j := pc - 1; j >= i; j-- {
            temp := j - i + 1
            if temp < longest {
                break
            }
            if j < pc-1 {
                sum2 -= primes[j+1]
            }
            if (temp % 2) == 0 != isEven {
                continue
            }
            bsum := big.NewInt(int64(sum2))
            if bsum.ProbablyPrime(5) {
                if temp > longest {
                    longest = temp
                    sIndices = []int{i}
                    eIndices = []int{j}
                    sums = []int{sum2}
                } else {
                    sIndices = append(sIndices, i)
                    eIndices = append(eIndices, j)
                    sums = append(sums, sum2)
                }
                break
            }
        }
    }
    return longest, sIndices, eIndices, sums
}

func main() {
    for _, limit := range []int{100, 250, 5000, 10000, 500000, 50000000} {
        longest, sIndices, eIndices, sums := calmoPrimes(limit)
        fmt.Println("For primes up to", rcu.Commatize(limit), "the longest sequence(s) of CalmoSoft primes")
        fmt.Println("having a length of", rcu.Commatize(longest), "is/are:\n")
        for i := 0; i < len(sIndices); i++ {
            cp1 := primes[sIndices[i] : sIndices[i]+6]
            cp2 := primes[eIndices[i]-5 : eIndices[i]+1]
            cps := ""
            for _, p := range cp1 {
                cps += fmt.Sprintf("%d + ", p)
            }
            cps += ".. + "
            for _, p := range cp2 {
                cps += fmt.Sprintf("%d + ", p)
            }
            fmt.Printf("%s = %s\n", cps[:len(cps)-3], rcu.Commatize(sums[i]))
        }
        fmt.Println()
    }
    fmt.Printf("Took %d ms\n", time.Since(start).Milliseconds())
}
