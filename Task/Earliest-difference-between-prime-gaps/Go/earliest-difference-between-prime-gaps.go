package main

import (
    "fmt"
    "rcu"
)

func main() {
    limit := int(1e9)
    gapStarts := make(map[int]int)
    primes := rcu.Primes(limit * 5)
    for i := 1; i < len(primes); i++ {
        gap := primes[i] - primes[i-1]
        if _, ok := gapStarts[gap]; !ok {
            gapStarts[gap] = primes[i-1]
        }
    }
    pm := 10
    gap1 := 2
    for {
        for _, ok := gapStarts[gap1]; !ok; {
            gap1 += 2
        }
        start1 := gapStarts[gap1]
        gap2 := gap1 + 2
        if _, ok := gapStarts[gap2]; !ok {
            gap1 = gap2 + 2
            continue
        }
        start2 := gapStarts[gap2]
        diff := start2 - start1
        if diff < 0 {
            diff = -diff
        }
        if diff > pm {
            cpm := rcu.Commatize(pm)
            cst1 := rcu.Commatize(start1)
            cst2 := rcu.Commatize(start2)
            cd := rcu.Commatize(diff)
            fmt.Printf("Earliest difference > %s between adjacent prime gap starting primes:\n", cpm)
            fmt.Printf("Gap %d starts at %s, gap %d starts at %s, difference is %s.\n\n", gap1, cst1, gap2, cst2, cd)
            if pm == limit {
                break
            }
            pm *= 10
        } else {
            gap1 = gap2
        }
    }
}
