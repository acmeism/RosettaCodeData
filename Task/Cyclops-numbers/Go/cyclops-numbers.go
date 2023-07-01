package main

import (
    "fmt"
    "rcu"
    "strconv"
    "strings"
)

func findFirst(list []int) (int, int) {
    for i, n := range list {
        if n > 1e7 {
            return n, i
        }
    }
    return -1, -1
}

func reverse(s string) string {
    chars := []rune(s)
    for i, j := 0, len(chars)-1; i < j; i, j = i+1, j-1 {
        chars[i], chars[j] = chars[j], chars[i]
    }
    return string(chars)
}

func main() {
    ranges := [][2]int{
        {0, 0}, {101, 909}, {11011, 99099}, {1110111, 9990999}, {111101111, 119101111},
    }
    var cyclops []int
    for _, r := range ranges {
        numDigits := len(fmt.Sprint(r[0]))
        center := numDigits / 2
        for i := r[0]; i <= r[1]; i++ {
            digits := rcu.Digits(i, 10)
            if digits[center] == 0 {
                count := 0
                for _, d := range digits {
                    if d == 0 {
                        count++
                    }
                }
                if count == 1 {
                    cyclops = append(cyclops, i)
                }
            }
        }
    }
    fmt.Println("The first 50 cyclops numbers are:")
    for i, n := range cyclops[0:50] {
        fmt.Printf("%6s ", rcu.Commatize(n))
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }
    n, i := findFirst(cyclops)
    ns, is := rcu.Commatize(n), rcu.Commatize(i)
    fmt.Printf("\nFirst such number > 10 million is %s at zero-based index %s\n", ns, is)

    var primes []int
    for _, n := range cyclops {
        if rcu.IsPrime(n) {
            primes = append(primes, n)
        }
    }
    fmt.Println("\n\nThe first 50 prime cyclops numbers are:")
    for i, n := range primes[0:50] {
        fmt.Printf("%6s ", rcu.Commatize(n))
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }
    n, i = findFirst(primes)
    ns, is = rcu.Commatize(n), rcu.Commatize(i)
    fmt.Printf("\nFirst such number > 10 million is %s at zero-based index %s\n", ns, is)

    var bpcyclops []int
    var ppcyclops []int
    for _, p := range primes {
        ps := fmt.Sprint(p)
        split := strings.Split(ps, "0")
        noMiddle, _ := strconv.Atoi(split[0] + split[1])
        if rcu.IsPrime(noMiddle) {
            bpcyclops = append(bpcyclops, p)
        }
        if ps == reverse(ps) {
            ppcyclops = append(ppcyclops, p)
        }
    }

    fmt.Println("\n\nThe first 50 blind prime cyclops numbers are:")
    for i, n := range bpcyclops[0:50] {
        fmt.Printf("%6s ", rcu.Commatize(n))
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }
    n, i = findFirst(bpcyclops)
    ns, is = rcu.Commatize(n), rcu.Commatize(i)
    fmt.Printf("\nFirst such number > 10 million is %s at zero-based index %s\n", ns, is)

    fmt.Println("\n\nThe first 50 palindromic prime cyclops numbers are:\n")
    for i, n := range ppcyclops[0:50] {
        fmt.Printf("%9s ", rcu.Commatize(n))
        if (i+1)%8 == 0 {
            fmt.Println()
        }
    }
    n, i = findFirst(ppcyclops)
    ns, is = rcu.Commatize(n), rcu.Commatize(i)
    fmt.Printf("\n\nFirst such number > 10 million is %s at zero-based index %s\n", ns, is)
}
