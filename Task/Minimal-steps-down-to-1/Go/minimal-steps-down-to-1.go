package main

import (
    "fmt"
    "strings"
)

const limit = 50000

var (
    divs, subs []int
    mins       [][]string
)

// Assumes the numbers are presented in order up to 'limit'.
func minsteps(n int) {
    if n == 1 {
        mins[1] = []string{}
        return
    }
    min := limit
    var p, q int
    var op byte
    for _, div := range divs {
        if n%div == 0 {
            d := n / div
            steps := len(mins[d]) + 1
            if steps < min {
                min = steps
                p, q, op = d, div, '/'
            }
        }
    }
    for _, sub := range subs {
        if d := n - sub; d >= 1 {
            steps := len(mins[d]) + 1
            if steps < min {
                min = steps
                p, q, op = d, sub, '-'
            }
        }
    }
    mins[n] = append(mins[n], fmt.Sprintf("%c%d -> %d", op, q, p))
    mins[n] = append(mins[n], mins[p]...)
}

func main() {
    for r := 0; r < 2; r++ {
        divs = []int{2, 3}
        if r == 0 {
            subs = []int{1}
        } else {
            subs = []int{2}
        }
        mins = make([][]string, limit+1)
        fmt.Printf("With: Divisors: %v, Subtractors: %v =>\n", divs, subs)
        fmt.Println("  Minimum number of steps to diminish the following numbers down to 1 is:")
        for i := 1; i <= limit; i++ {
            minsteps(i)
            if i <= 10 {
                steps := len(mins[i])
                plural := "s"
                if steps == 1 {
                    plural = " "
                }
                fmt.Printf("    %2d: %d step%s: %s\n", i, steps, plural, strings.Join(mins[i], ", "))
            }
        }
        for _, lim := range []int{2000, 20000, 50000} {
            max := 0
            for _, min := range mins[0 : lim+1] {
                m := len(min)
                if m > max {
                    max = m
                }
            }
            var maxs []int
            for i, min := range mins[0 : lim+1] {
                if len(min) == max {
                    maxs = append(maxs, i)
                }
            }
            nums := len(maxs)
            verb, verb2, plural := "are", "have", "s"
            if nums == 1 {
                verb, verb2, plural = "is", "has", ""
            }
            fmt.Printf("  There %s %d number%s in the range 1-%d ", verb, nums, plural, lim)
            fmt.Printf("that %s maximum 'minimal steps' of %d:\n", verb2, max)
            fmt.Println("   ", maxs)
        }
        fmt.Println()
    }
}
