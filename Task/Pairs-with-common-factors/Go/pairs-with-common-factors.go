package main

import (
    "fmt"
    "rcu"
)

func totient(n uint64) uint64 {
    tot := n
    i := uint64(2)
    for i*i <= n {
        if n%i == 0 {
            for n%i == 0 {
                n /= i
            }
            tot -= tot / i
        }
        if i == 2 {
            i = 1
        }
        i += 2
    }
    if n > 1 {
        tot -= tot / n
    }
    return tot
}

func ord(c int) string {
    m := c % 100
    if m >= 4 && m <= 20 {
        return "th"
    }
    m %= 10
    switch m {
    case 1:
        return "st"
    case 2:
        return "md"
    case 3:
        return "rd"
    default:
        return "th"
    }
}

func main() {
    const max = 1_000_000
    a := make([]uint64, max)
    sumPhi := uint64(0)
    for n := uint64(1); n <= uint64(max); n++ {
        sumPhi += totient(n)
        if rcu.IsPrime(n) {
            a[n-1] = a[n-2]
        } else {
            a[n-1] = n*(n-1)/2 + 1 - sumPhi
        }
    }
    fmt.Println("Number of pairs with common factors - first one hundred terms:")
    rcu.PrintTable(a[:100], 10, 6, true)
    fmt.Println()
    for limit := 1; limit <= max; limit *= 10 {
        fmt.Printf("The %s%s term: %s\n", rcu.Commatize(limit), ord(limit), rcu.Commatize(a[limit-1]))
    }
}
