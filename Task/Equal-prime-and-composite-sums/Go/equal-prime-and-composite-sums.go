package main

import (
    "fmt"
    "log"
    "rcu"
    "sort"
)

func ord(n int) string {
    if n < 0 {
        log.Fatal("Argument must be a non-negative integer.")
    }
    m := n % 100
    if m >= 4 && m <= 20 {
        return fmt.Sprintf("%sth", rcu.Commatize(n))
    }
    m %= 10
    suffix := "th"
    if m == 1 {
        suffix = "st"
    } else if m == 2 {
        suffix = "nd"
    } else if m == 3 {
        suffix = "rd"
    }
    return fmt.Sprintf("%s%s", rcu.Commatize(n), suffix)
}

func main() {
    limit := int(4 * 1e8)
    c := rcu.PrimeSieve(limit-1, true)
    var compSums []int
    var primeSums []int
    csum := 0
    psum := 0
    for i := 2; i < limit; i++ {
        if c[i] {
            csum += i
            compSums = append(compSums, csum)
        } else {
            psum += i
            primeSums = append(primeSums, psum)
        }
    }

    for i := 0; i < len(primeSums); i++ {
        ix := sort.SearchInts(compSums, primeSums[i])
        if ix < len(compSums) && compSums[ix] == primeSums[i] {
            cps := rcu.Commatize(primeSums[i])
            fmt.Printf("%21s - %12s prime sum, %12s composite sum\n", cps, ord(i+1), ord(ix+1))
        }
    }
}
