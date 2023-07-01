package main

import (
    "fmt"
    "rcu"
    "strconv"
    "strings"
)

func main() {
    count := 0
    k := 11 * 11
    var res []int
    for count < 20 {
        if k%3 == 0 || k%5 == 0 || k%7 == 0 {
            k += 2
            continue
        }
        factors := rcu.PrimeFactors(k)
        if len(factors) > 1 {
            s := strconv.Itoa(k)
            includesAll := true
            prev := -1
            for _, f := range factors {
                if f == prev {
                    continue
                }
                fs := strconv.Itoa(f)
                if strings.Index(s, fs) == -1 {
                    includesAll = false
                    break
                }
            }
            if includesAll {
                res = append(res, k)
                count++
            }
        }
        k += 2
    }
    for _, e := range res[0:10] {
        fmt.Printf("%10s ", rcu.Commatize(e))
    }
    fmt.Println()
    for _, e := range res[10:20] {
        fmt.Printf("%10s ", rcu.Commatize(e))
    }
    fmt.Println()
}
