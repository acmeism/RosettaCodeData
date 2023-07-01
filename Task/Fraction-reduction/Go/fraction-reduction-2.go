package main

import (
    "fmt"
    "time"
)

type result struct {
    n    int
    nine [9]int
}

func indexOf(n int, s []int) int {
    for i, j := range s {
        if n == j {
            return i
        }
    }
    return -1
}

func bIndexOf(b bool, s []bool) int {
    for i, j := range s {
        if b == j {
            return i
        }
    }
    return -1
}

func toNumber(digits []int, removeDigit int) int {
    digits2 := digits
    if removeDigit != 0 {
        digits2 = make([]int, len(digits))
        copy(digits2, digits)
        d := indexOf(removeDigit, digits2)
        copy(digits2[d:], digits2[d+1:])
        digits2[len(digits2)-1] = 0
        digits2 = digits2[:len(digits2)-1]
    }
    res := digits2[0]
    for i := 1; i < len(digits2); i++ {
        res = res*10 + digits2[i]
    }
    return res
}

func nDigits(n int) []result {
    var res []result
    digits := make([]int, n)
    var used [9]bool
    for i := 0; i < n; i++ {
        digits[i] = i + 1
        used[i] = true
    }
    for {
        var nine [9]int
        for i := 0; i < len(used); i++ {
            if used[i] {
                nine[i] = toNumber(digits, i+1)
            }
        }
        res = append(res, result{toNumber(digits, 0), nine})
        found := false
        for i := n - 1; i >= 0; i-- {
            d := digits[i]
            if !used[d-1] {
                panic("something went wrong with 'used' array")
            }
            used[d-1] = false
            for j := d; j < 9; j++ {
                if !used[j] {
                    used[j] = true
                    digits[i] = j + 1
                    for k := i + 1; k < n; k++ {
                        digits[k] = bIndexOf(false, used[:]) + 1
                        used[digits[k]-1] = true
                    }
                    found = true
                    break
                }
            }
            if found {
                break
            }
        }
        if !found {
            break
        }
    }
    return res
}

func main() {
    start := time.Now()
    for n := 2; n <= 5; n++ {
        rs := nDigits(n)
        count := 0
        var omitted [9]int
        for i := 0; i < len(rs)-1; i++ {
            xn, rn := rs[i].n, rs[i].nine
            for j := i + 1; j < len(rs); j++ {
                xd, rd := rs[j].n, rs[j].nine
                for k := 0; k < 9; k++ {
                    yn, yd := rn[k], rd[k]
                    if yn != 0 && yd != 0 &&
                        float64(xn)/float64(xd) == float64(yn)/float64(yd) {
                        count++
                        omitted[k]++
                        if count <= 12 {
                            fmt.Printf("%d/%d => %d/%d (removed %d)\n", xn, xd, yn, yd, k+1)
                        }
                    }
                }
            }
        }
        fmt.Printf("%d-digit fractions found:%d, omitted %v\n\n", n, count, omitted)
    }
    fmt.Printf("Took %s\n", time.Since(start))
}
