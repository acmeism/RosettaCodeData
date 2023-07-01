package main

import (
    "fmt"
    "rcu"
    "strconv"
)

func isColorful(n int) bool {
    if n < 0 {
        return false
    }
    if n < 10 {
        return true
    }
    digits := rcu.Digits(n, 10)
    for _, d := range digits {
        if d == 0 || d == 1 {
            return false
        }
    }
    set := make(map[int]bool)
    for _, d := range digits {
        set[d] = true
    }
    dc := len(digits)
    if len(set) < dc {
        return false
    }
    for k := 2; k <= dc; k++ {
        for i := 0; i <= dc-k; i++ {
            prod := 1
            for j := i; j <= i+k-1; j++ {
                prod *= digits[j]
            }
            if ok := set[prod]; ok {
                return false
            }
            set[prod] = true
        }
    }
    return true
}

var count = make([]int, 9)
var used = make([]bool, 11)
var largest = 0

func countColorful(taken int, n string) {
    if taken == 0 {
        for digit := 0; digit < 10; digit++ {
            dx := digit + 1
            used[dx] = true
            t := 1
            if digit < 2 {
                t = 9
            }
            countColorful(t, string(digit+48))
            used[dx] = false
        }
    } else {
        nn, _ := strconv.Atoi(n)
        if isColorful(nn) {
            ln := len(n)
            count[ln]++
            if nn > largest {
                largest = nn
            }
        }
        if taken < 9 {
            for digit := 2; digit < 10; digit++ {
                dx := digit + 1
                if !used[dx] {
                    used[dx] = true
                    countColorful(taken+1, n+string(digit+48))
                    used[dx] = false
                }
            }
        }
    }
}

func main() {
    var cn []int
    for i := 0; i < 100; i++ {
        if isColorful(i) {
            cn = append(cn, i)
        }
    }
    fmt.Println("The", len(cn), "colorful numbers less than 100 are:")
    for i := 0; i < len(cn); i++ {
        fmt.Printf("%2d ", cn[i])
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }

    countColorful(0, "")
    fmt.Println("\n\nThe largest possible colorful number is:")
    fmt.Println(rcu.Commatize(largest))

    fmt.Println("\nCount of colorful numbers for each order of magnitude:")
    pow := 10
    for dc := 1; dc < len(count); dc++ {
        cdc := rcu.Commatize(count[dc])
        pc := 100 * float64(count[dc]) / float64(pow)
        fmt.Printf("  %d digit colorful number count: %6s - %7.3f%%\n", dc, cdc, pc)
        if pow == 10 {
            pow = 90
        } else {
            pow *= 10
        }
    }

    sum := 0
    for _, c := range count {
        sum += c
    }
    fmt.Printf("\nTotal colorful numbers: %s\n", rcu.Commatize(sum))
}
