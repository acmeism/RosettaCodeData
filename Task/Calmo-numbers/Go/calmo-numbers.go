package main

import (
    "fmt"
    "rcu"
    "strconv"
    "strings"
)

func main() {
    const limit = 1000
    fmt.Println("Calmo numbers under 1,000:\n")
    fmt.Println("Number  Eligible divisors      Partial sums")
    fmt.Println("-------------------------------------------")
    for i := 2; i < limit; i++ {
        ed := rcu.ProperDivisors(i)[1:]
        l := len(ed)
        if l == 0 || l%3 != 0 {
            continue
        }
        isCalmo := true
        var ps []int
        for j := 0; j < l; j += 3 {
            sum := ed[j] + ed[j+1] + ed[j+2]
            if !rcu.IsPrime(sum) {
                isCalmo = false
                break
            }
            ps = append(ps, sum)
        }
        if isCalmo {
            eds := make([]string, len(ed))
            for k, e := range ed {
                eds[k] = strconv.Itoa(e)
            }
            seds := "[" + strings.Join(eds, " ") + "]"
            fmt.Printf("%3d     %-21s  %v\n", i, seds, ps)
        }
    }
}
