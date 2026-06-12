package main

import "fmt"

var (
    n      = 3
    values = []string{"A", "B", "C", "D"}
    k      = len(values)
    decide = func(p []string) bool {
        return p[0] == "B" && p[1] == "C"
    }
)

func main() {
    pn := make([]int, n)
    p := make([]string, n)
    for {
        // generate permutaton
        for i, x := range pn {
            p[i] = values[x]
        }
        // show progress
        fmt.Println(p)
        // pass to deciding function
        if decide(p) {
            return // terminate early
        }
        // increment permutation number
        for i := 0; ; {
            pn[i]++
            if pn[i] < k {
                break
            }
            pn[i] = 0
            i++
            if i == n {
                return // all permutations generated
            }
        }
    }
}
