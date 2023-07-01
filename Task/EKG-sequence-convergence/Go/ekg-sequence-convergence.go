package main

import (
    "fmt"
    "sort"
)

func contains(a []int, b int) bool {
    for _, j := range a {
        if j == b {
            return true
        }
    }
    return false
}

func gcd(a, b int) int {
    for a != b {
        if a > b {
            a -= b
        } else {
            b -= a
        }
    }
    return a
}

func areSame(s, t []int) bool {
    le := len(s)
    if le != len(t) {
        return false
    }
    sort.Ints(s)
    sort.Ints(t)
    for i := 0; i < le; i++ {
        if s[i] != t[i] {
            return false
        }
    }
    return true
}

func main() {
    const limit = 100
    starts := [5]int{2, 5, 7, 9, 10}
    var ekg [5][limit]int

    for s, start := range starts {
        ekg[s][0] = 1
        ekg[s][1] = start
        for n := 2; n < limit; n++ {
            for i := 2; ; i++ {
                // a potential sequence member cannot already have been used
                // and must have a factor in common with previous member
                if !contains(ekg[s][:n], i) && gcd(ekg[s][n-1], i) > 1 {
                    ekg[s][n] = i
                    break
                }
            }
        }
        fmt.Printf("EKG(%2d): %v\n", start, ekg[s][:30])
    }

    // now compare EKG5 and EKG7 for convergence
    for i := 2; i < limit; i++ {
        if ekg[1][i] == ekg[2][i] && areSame(ekg[1][:i], ekg[2][:i]) {
            fmt.Println("\nEKG(5) and EKG(7) converge at term", i+1)
            return
        }
    }
    fmt.Println("\nEKG5(5) and EKG(7) do not converge within", limit, "terms")
}
