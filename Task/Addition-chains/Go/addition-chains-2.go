package main

import (
    "fmt"
    "time"
)

const (
    maxLen       = 13
    maxNonBrauer = 382
)

func max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func contains(s []int, n int) bool {
    for _, i := range s {
        if i == n {
            return true
        }
    }
    return false
}

func isBrauer(a []int) bool {
    for i := 2; i < len(a); i++ {
        ok := false
        for j := i - 1; j >= 0; j-- {
            if a[i-1]+a[j] == a[i] {
                ok = true
                break
            }
        }
        if !ok {
            return false
        }
    }
    return true
}

var (
    brauerCount, nonBrauerCount     int
    brauerExample, nonBrauerExample string
)

func additionChains(target, length int, chosen []int) int {
    le := len(chosen)
    last := chosen[le-1]
    if last == target {
        if le < length {
            brauerCount = 0
            nonBrauerCount = 0
        }
        if isBrauer(chosen) {
            brauerCount++
            brauerExample = fmt.Sprint(chosen)
        } else {
            nonBrauerCount++
            nonBrauerExample = fmt.Sprint(chosen)
        }
        return le
    }
    if le == length {
        return length
    }
    if target > maxNonBrauer {
        for i := le - 1; i >= 0; i-- {
            next := last + chosen[i]
            if next <= target && next > chosen[len(chosen)-1] && i < length {
                length = additionChains(target, length, append(chosen, next))
            }
        }
    } else {
        var ndone []int
        for {
            for i := le - 1; i >= 0; i-- {
                next := last + chosen[i]
                if next <= target && next > chosen[len(chosen)-1] && i < length &&
                    !contains(ndone, next) {
                    ndone = append(ndone, next)
                    length = additionChains(target, length, append(chosen, next))
                }
            }
            le--
            if le == 0 {
                break
            }
            last = chosen[le-1]
        }
    }
    return length
}

func main() {
    start := time.Now()
    nums := []int{7, 14, 21, 29, 32, 42, 64, 47, 79, 191, 382, 379}
    fmt.Println("Searching for Brauer chains up to a minimum length of", maxLen-1)
    for _, num := range nums {
        brauerCount = 0
        nonBrauerCount = 0
        le := additionChains(num, maxLen, []int{1})
        fmt.Println("\nN =", num)
        fmt.Printf("Minimum length of chains : L(%d) = %d\n", num, le-1)
        fmt.Println("Number of minimum length Brauer chains :", brauerCount)
        if brauerCount > 0 {
            fmt.Println("Brauer example :", brauerExample)
        }
        fmt.Println("Number of minimum length non-Brauer chains :", nonBrauerCount)
        if nonBrauerCount > 0 {
            fmt.Println("Non-Brauer example :", nonBrauerExample)
        }
    }
    fmt.Printf("\nTook %s\n", time.Since(start))
}
