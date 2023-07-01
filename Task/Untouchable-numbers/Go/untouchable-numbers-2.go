package main

import (
    "fmt"
    "rcu"
)

func main() {
    limit := 1000000
    m := 63
    c := rcu.PrimeSieve(limit, false)
    n := m*limit + 1
    sumDivs := make([]int, n)
    for i := 1; i < n; i++ {
        for j := i; j < n; j += i {
            sumDivs[j] += i
        }
    }
    s := make([]bool, n) // all false
    for i := 1; i < n; i++ {
        sum := sumDivs[i] - i // proper divs sum
        if sum <= n {
            s[sum] = true
        }
    }
    untouchable := []int{2, 5}
    for n := 6; n <= limit; n += 2 {
        if !s[n] && c[n-1] && c[n-3] {
            untouchable = append(untouchable, n)
        }
    }
    fmt.Println("List of untouchable numbers <=   2,000:")
    count := 0
    for i := 0; untouchable[i] <= 2000; i++ {
        fmt.Printf("%6s", rcu.Commatize(untouchable[i]))
        if (i+1)%10 == 0 {
            fmt.Println()
        }
        count++
    }
    fmt.Printf("\n\n%7s untouchable numbers were found  <=     2,000\n", rcu.Commatize(count))
    p := 10
    count = 0
    for _, n := range untouchable {
        count++
        if n > p {
            cc := rcu.Commatize(count - 1)
            cp := rcu.Commatize(p)
            fmt.Printf("%7s untouchable numbers were found  <= %9s\n", cc, cp)
            p = p * 10
            if p == limit {
                break
            }
        }
    }
    cu := rcu.Commatize(len(untouchable))
    cl := rcu.Commatize(limit)
    fmt.Printf("%7s untouchable numbers were found  <= %s\n", cu, cl)
}
