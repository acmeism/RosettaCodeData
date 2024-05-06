package main

import (
    "fmt"
    "math"
    "math/big"
)

type record struct{ num, count int }

var (
    bi     = new(big.Int)
    primes = []int{2}
)

func isPrime(n int) bool {
    bi.SetUint64(uint64(n))
    return bi.ProbablyPrime(0)
}

func sieve(limit int) {
    c := make([]bool, limit+1) // composite = true
    // no need to process even numbers
    p := 3
    for {
        p2 := p * p
        if p2 > limit {
            break
        }
        for i := p2; i <= limit; i += 2 * p {
            c[i] = true
        }
        for {
            p += 2
            if !c[p] {
                break
            }
        }
    }
    for i := 3; i <= limit; i += 2 {
        if !c[i] {
            primes = append(primes, i)
        }
    }
}

func countDivisors(n int) int {
    count := 1
    for i, p := 0, primes[0]; p*p <= n; i, p = i+1, primes[i+1] {
        if n%p != 0 {
            continue
        }
        n /= p
        count2 := 1
        for n%p == 0 {
            n /= p
            count2++
        }
        count *= (count2 + 1)
        if n == 1 {
            return count
        }
    }
    if n != 1 {
        count *= 2
    }
    return count
}

func isOdd(x int) bool {
    return x%2 == 1
}

func main() {
    sieve(22000)
    const max = 45
    records := [max + 1]record{}
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
            count := records[i].count
            if count == i {
                fmt.Printf("%2d : %d\n", i, records[i].num)
                continue
            }
            odd := isOdd(i)
            k := records[i].num
            l := 1
            if !odd && i != 2 && i != 10 {
                l = 2
            }
            for j := k + l; ; j += l {
                if odd {
                    sq := int(math.Sqrt(float64(j)))
                    if sq*sq != j {
                        continue
                    }
                }
                cd := countDivisors(j)
                if cd == i {
                    count++
                    if count == i {
                        fmt.Printf("%2d : %d\n", i, j)
                        break
                    }
                } else if cd > i && cd <= max && records[cd].count < cd &&
                    j > records[cd].num && (l == 1 || (l == 2 && !isOdd(cd))) {
                    records[cd].num = j
                    records[cd].count++
                }
            }
        }
    }
}
