package main

import (
    "fmt"
    "rcu"
    "strconv"
)

func contains(a []int, n int) bool {
    for _, e := range a {
        if e == n {
            return true
        }
    }
    return false
}

func main() {
    for b := 2; b <= 36; b++ {
        if rcu.IsPrime(b) {
            continue
        }
        count := 0
        var rhonda []int
        for n := 1; count < 15; n++ {
            digits := rcu.Digits(n, b)
            if !contains(digits, 0) {
                var anyEven = false
                for _, d := range digits {
                    if d%2 == 0 {
                        anyEven = true
                        break
                    }
                }
                if b != 10 || (contains(digits, 5) && anyEven) {
                    calc1 := 1
                    for _, d := range digits {
                        calc1 *= d
                    }
                    calc2 := b * rcu.SumInts(rcu.PrimeFactors(n))
                    if calc1 == calc2 {
                        rhonda = append(rhonda, n)
                        count++
                    }
                }
            }
        }
        if len(rhonda) > 0 {
            fmt.Printf("\nFirst 15 Rhonda numbers in base %d:\n", b)
            rhonda2 := make([]string, len(rhonda))
            counts2 := make([]int, len(rhonda))
            for i, r := range rhonda {
                rhonda2[i] = fmt.Sprintf("%d", r)
                counts2[i] = len(rhonda2[i])
            }
            rhonda3 := make([]string, len(rhonda))
            counts3 := make([]int, len(rhonda))
            for i, r := range rhonda {
                rhonda3[i] = strconv.FormatInt(int64(r), b)
                counts3[i] = len(rhonda3[i])
            }
            maxLen2 := rcu.MaxInts(counts2)
            maxLen3 := rcu.MaxInts(counts3)
            maxLen := maxLen2
            if maxLen3 > maxLen {
                maxLen = maxLen3
            }
            maxLen++
            fmt.Printf("In base 10: %*s\n", maxLen, rhonda2)
            fmt.Printf("In base %-2d: %*s\n", b, maxLen, rhonda3)
        }
    }
}
