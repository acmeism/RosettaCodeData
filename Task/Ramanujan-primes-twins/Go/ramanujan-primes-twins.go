package main

import (
    "fmt"
    "math"
    "rcu"
    "time"
)

var count []int

func primeCounter(limit int) {
    count = make([]int, limit)
    for i := 0; i < limit; i++ {
        count[i] = 1
    }
    if limit > 0 {
        count[0] = 0
    }
    if limit > 1 {
        count[1] = 0
    }
    for i := 4; i < limit; i += 2 {
        count[i] = 0
    }
    for p, sq := 3, 9; sq < limit; p += 2 {
        if count[p] != 0 {
            for q := sq; q < limit; q += p << 1 {
                count[q] = 0
            }
        }
        sq += (p + 1) << 2
    }
    sum := 0
    for i := 0; i < limit; i++ {
        sum += count[i]
        count[i] = sum
    }
}

func primeCount(n int) int {
    if n < 1 {
        return 0
    }
    return count[n]
}

func ramanujanMax(n int) int {
    fn := float64(n)
    return int(math.Ceil(4 * fn * math.Log(4*fn)))
}

func ramanujanPrime(n int) int {
    if n == 1 {
        return 2
    }
    for i := ramanujanMax(n); i >= 2*n; i-- {
        if i%2 == 1 {
            continue
        }
        if primeCount(i)-primeCount(i/2) < n {
            return i + 1
        }
    }
    return 0
}

func rpc(p int) int { return primeCount(p) - primeCount(p/2) }

func main() {
    for _, limit := range []int{1e5, 1e6} {
        start := time.Now()
        primeCounter(1 + ramanujanMax(limit))
        rplim := ramanujanPrime(limit)
        climit := rcu.Commatize(limit)
        fmt.Printf("The %sth Ramanujan prime is %s\n", climit, rcu.Commatize(rplim))
        r := rcu.Primes(rplim)
        c := make([]int, len(r))
        for i := 0; i < len(c); i++ {
            c[i] = rpc(r[i])
        }
        ok := c[len(c)-1]
        for i := len(c) - 2; i >= 0; i-- {
            if c[i] < ok {
                ok = c[i]
            } else {
                c[i] = 0
            }
        }
        var fr []int
        for i, r := range r {
            if c[i] != 0 {
                fr = append(fr, r)
            }
        }
        twins := 0
        for i := 0; i < len(fr)-1; i++ {
            if fr[i]+2 == fr[i+1] {
                twins++
            }
        }
        fmt.Printf("There are %s twins in the first %s Ramanujan primes.\n", rcu.Commatize(twins), climit)
        fmt.Println("Took", time.Since(start))
        fmt.Println()
    }
}
