package main

import (
    "fmt"
    big "github.com/ncw/gmp"
    "rcu"
)

func main() {
    const limit = 29
    count := 0
    p := 1
    one := big.NewInt(1)
    three := big.NewInt(3)
    w := new(big.Int)
    for count < limit {
        for {
            p += 2
            if rcu.IsPrime(p) {
                break
            }
        }
        w.SetUint64(1)
        w.Lsh(w, uint(p))
        w.Add(w, one)
        w.Quo(w, three)
        if w.ProbablyPrime(15) {
            count++
            ws := w.String()
            le := len(ws)
            if le >= 34 {
                ws = ws[0:15] + "..." + ws[le-15:]
            }
            fmt.Printf("%5d: %s", p, ws)
            if le >= 34 {
                fmt.Printf(" (%d digits)", le)
            }
            println()
        }
    }
}
