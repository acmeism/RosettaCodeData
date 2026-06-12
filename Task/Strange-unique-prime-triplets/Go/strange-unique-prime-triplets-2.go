package main

import "fmt"

var sieved []bool
var p = []int{2}

func sieve(limit int) []bool {
    limit++
    // True denotes composite, false denotes prime.
    c := make([]bool, limit) // all false by default
    c[0] = true
    c[1] = true
    // no need to bother with even numbers over 2 for this task
    p := 3 // Start from 3.
    for {
        p2 := p * p
        if p2 >= limit {
            break
        }
        for i := p2; i < limit; i += 2 * p {
            c[i] = true
        }
        for {
            p += 2
            if !c[p] {
                break
            }
        }
    }
    return c
}

func commatize(n int) string {
    s := fmt.Sprintf("%d", n)
    if n < 0 {
        s = s[1:]
    }
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    if n >= 0 {
        return s
    }
    return "-" + s
}

func strangePrimes(n int, countOnly bool) int {
    c := 0
    f := "%2d: %2d + %2d + %2d = %2d\n"
    var r, s int
    m := 0
    for ; m < len(p) && p[m] <= n; m++ {
    }
    for i := 1; i < m-2; i++ {
        for j := i + 1; j < m-1; j++ {
            r = p[i] + p[j]
            for k := j + 1; k < m; k++ {
                s = r + p[k]
                if !sieved[s] {
                    c++
                    if !countOnly {
                        fmt.Printf(f, c, p[i], p[j], p[k], s)
                    }
                }
            }
        }
    }
    return c
}

func main() {
    const max = 1000
    sieved = sieve(3*max)
    for i := 3; i <= max; i += 2 {
        if !sieved[i] {
            p = append(p, i)
        }
    }
    fmt.Println("Unique prime triples under 30 which sum to a prime:")
    strangePrimes(29, false)
    cs := commatize(strangePrimes(999, true))
    fmt.Printf("\nThere are %s unique prime triples under 1,000 which sum to a prime.\n", cs)
}
