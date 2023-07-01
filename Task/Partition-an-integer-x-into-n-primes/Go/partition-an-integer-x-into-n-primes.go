package main

import (
    "fmt"
    "log"
)

var (
    primes     = sieve(100000)
    foundCombo = false
)

func sieve(limit uint) []uint {
    primes := []uint{2}
    c := make([]bool, limit+1) // composite = true
    // no need to process even numbers > 2
    p := uint(3)
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
    for i := uint(3); i <= limit; i += 2 {
        if !c[i] {
            primes = append(primes, i)
        }
    }
    return primes
}

func findCombo(k, x, m, n uint, combo []uint) {
    if k >= m {
        sum := uint(0)
        for _, c := range combo {
            sum += primes[c]
        }
        if sum == x {
            s := "s"
            if m == 1 {
                s = " "
            }
            fmt.Printf("Partitioned %5d with %2d prime%s: ", x, m, s)
            for i := uint(0); i < m; i++ {
                fmt.Print(primes[combo[i]])
                if i < m-1 {
                    fmt.Print("+")
                } else {
                    fmt.Println()
                }
            }
            foundCombo = true
        }
    } else {
        for j := uint(0); j < n; j++ {
            if k == 0 || j > combo[k-1] {
                combo[k] = j
                if !foundCombo {
                    findCombo(k+1, x, m, n, combo)
                }
            }
        }
    }
}

func partition(x, m uint) error {
    if !(x >= 2 && m >= 1 && m < x) {
        return fmt.Errorf("x must be at least 2 and m in [1, x)")
    }
    n := uint(0)
    for _, prime := range primes {
        if prime <= x {
            n++
        }
    }
    if n < m {
        return fmt.Errorf("not enough primes")
    }
    combo := make([]uint, m)
    foundCombo = false
    findCombo(0, x, m, n, combo)
    if !foundCombo {
        s := "s"
        if m == 1 {
            s = " "
        }
        fmt.Printf("Partitioned %5d with %2d prime%s: (impossible)\n", x, m, s)
    }
    return nil
}

func main() {
    a := [...][2]uint{
        {99809, 1}, {18, 2}, {19, 3}, {20, 4}, {2017, 24},
        {22699, 1}, {22699, 2}, {22699, 3}, {22699, 4}, {40355, 3},
    }
    for _, p := range a {
        err := partition(p[0], p[1])
        if err != nil {
            log.Println(err)
        }
    }
}
