package main

import "fmt"

var ffr, ffs func(int) int

// The point of the init function is to encapsulate r and s.  If you are
// not concerned about that or do not want that, r and s can be variables at
// package level and ffr and ffs can be ordinary functions at package level.
func init() {
    // task 1, 2
    r := []int{0, 1}
    s := []int{0, 2}

    ffr = func(n int) int {
        for len(r) <= n {
            nrk := len(r) - 1       // last n for which r(n) is known
            rNxt := r[nrk] + s[nrk] // next value of r:  r(nrk+1)
            r = append(r, rNxt)     // extend sequence r by one element
            for sn := r[nrk] + 2; sn < rNxt; sn++ {
                s = append(s, sn)   // extend sequence s up to rNext
            }
            s = append(s, rNxt+1)   // extend sequence s one past rNext
        }
        return r[n]
    }

    ffs = func(n int) int {
        for len(s) <= n {
            ffr(len(r))
        }
        return s[n]
    }
}

func main() {
    // task 3
    for n := 1; n <= 10; n++ {
        fmt.Printf("r(%d): %d\n", n, ffr(n))
    }
    // task 4
    var found [1001]int
    for n := 1; n <= 40; n++ {
        found[ffr(n)]++
    }
    for n := 1; n <= 960; n++ {
        found[ffs(n)]++
    }
    for i := 1; i <= 1000; i++ {
        if found[i] != 1 {
            fmt.Println("task 4: FAIL")
            return
        }
    }
    fmt.Println("task 4: PASS")
}
