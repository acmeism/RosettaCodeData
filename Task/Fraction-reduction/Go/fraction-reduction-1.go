package main

import (
    "fmt"
    "time"
)

func indexOf(n int, s []int) int {
    for i, j := range s {
        if n == j {
            return i
        }
    }
    return -1
}

func getDigits(n, le int, digits []int) bool {
    for n > 0 {
        r := n % 10
        if r == 0 || indexOf(r, digits) >= 0 {
            return false
        }
        le--
        digits[le] = r
        n /= 10
    }
    return true
}

var pows = [5]int{1, 10, 100, 1000, 10000}

func removeDigit(digits []int, le, idx int) int {
    sum := 0
    pow := pows[le-2]
    for i := 0; i < le; i++ {
        if i == idx {
            continue
        }
        sum += digits[i] * pow
        pow /= 10
    }
    return sum
}

func main() {
    start := time.Now()
    lims := [5][2]int{
        {12, 97},
        {123, 986},
        {1234, 9875},
        {12345, 98764},
        {123456, 987653},
    }
    var count [5]int
    var omitted [5][10]int
    for i, lim := range lims {
        nDigits := make([]int, i+2)
        dDigits := make([]int, i+2)
        blank := make([]int, i+2)
        for n := lim[0]; n <= lim[1]; n++ {
            copy(nDigits, blank)
            nOk := getDigits(n, i+2, nDigits)
            if !nOk {
                continue
            }
            for d := n + 1; d <= lim[1]+1; d++ {
                copy(dDigits, blank)
                dOk := getDigits(d, i+2, dDigits)
                if !dOk {
                    continue
                }
                for nix, digit := range nDigits {
                    if dix := indexOf(digit, dDigits); dix >= 0 {
                        rn := removeDigit(nDigits, i+2, nix)
                        rd := removeDigit(dDigits, i+2, dix)
                        if float64(n)/float64(d) == float64(rn)/float64(rd) {
                            count[i]++
                            omitted[i][digit]++
                            if count[i] <= 12 {
                                fmt.Printf("%d/%d = %d/%d by omitting %d's\n", n, d, rn, rd, digit)
                            }
                        }
                    }
                }
            }
        }
        fmt.Println()
    }

    for i := 2; i <= 6; i++ {
        fmt.Printf("There are %d %d-digit fractions of which:\n", count[i-2], i)
        for j := 1; j <= 9; j++ {
            if omitted[i-2][j] == 0 {
                continue
            }
            fmt.Printf("%6d have %d's omitted\n", omitted[i-2][j], j)
        }
        fmt.Println()
    }
    fmt.Printf("Took %s\n", time.Since(start))
}
