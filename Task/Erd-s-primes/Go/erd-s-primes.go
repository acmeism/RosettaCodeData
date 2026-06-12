package main

import (
    "fmt"
    "rcu"
)

func main() {
    limit := int(1e6)
    lowerLimit := 2500
    c := rcu.PrimeSieve(limit-1, true)
    var erdos []int
    lastErdos := 0
    ec := 0
    for i := 2; i < limit; {
        if !c[i] {
            found := true
            for j, fact := 1, 1; fact < i; {
                if !c[i-fact] {
                    found = false
                    break
                }
                j++
                fact = fact * j
            }
            if found {
                if i < lowerLimit {
                    erdos = append(erdos, i)
                }
                lastErdos = i
                ec++
            }
        }
        if i > 2 {
            i += 2
        } else {
            i += 1
        }
    }
    fmt.Printf("The %d Erdős primes under %s are\n", len(erdos), rcu.Commatize(lowerLimit))
    rcu.PrintTable(erdos, 10, 6, false)
    fmt.Printf("\nThe %s Erdős prime is %s.\n", rcu.Commatize(ec), rcu.Commatize(lastErdos))
}
