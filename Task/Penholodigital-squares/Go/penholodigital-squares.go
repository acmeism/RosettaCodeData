package main

import (
    "fmt"
    "math"
    "rcu"
    "strconv"
)

func reverse(s string) string {
    r := make([]byte, len(s))
    for i := 0; i < len(s); i++ {
        r[i] = s[len(s)-1-i]
    }
    return string(r)
}

func main() {
    primes := []int{2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47}
    digits := "123456789ABCDEF"
    for b := 9; b <= 16; b++ {
        master := 1
        for d := 1; d < b; d++ {
            master *= primes[d-1]
        }
        var phd []int
        smin, _ := strconv.ParseInt(digits[0:b-1], b, 64)
        min := int(math.Ceil(math.Sqrt(float64(smin))))
        smax, _ := strconv.ParseInt(reverse(digits[0:b-1]), b, 64)
        max := int(math.Floor(math.Sqrt(float64(smax))))
        factors := rcu.PrimeFactors(b - 1)
        div := factors[len(factors)-1]
        for i := min; i <= max; i++ {
            if (i % div) != 0 {
                continue
            }
            sq := i * i
            digs := rcu.Digits(sq, b)
            containsZero := false
            key := 1
            for _, dig := range digs {
                if dig == 0 {
                    containsZero = true
                    break
                }
                key *= primes[dig-1]
            }
            if containsZero {
                continue
            }
            if key == master {
                phd = append(phd, i)
            }
        }
        fmt.Println("There is a total of", len(phd), "penholodigital squares in base", b, "\b:")
        if b > 13 {
            phd = []int{phd[0], phd[len(phd)-1]}
        }
        for i := 0; i < len(phd); i++ {
            sq2 := phd[i] * phd[i]
            fmt.Printf("%s² = %s  ", strconv.FormatInt(int64(phd[i]), b), strconv.FormatInt(int64(sq2), b))
            if (i+1)%3 == 0 {
                fmt.Println()
            }
        }
        if len(phd)%3 != 0 {
            fmt.Println()
        }
        fmt.Println()
    }
}
