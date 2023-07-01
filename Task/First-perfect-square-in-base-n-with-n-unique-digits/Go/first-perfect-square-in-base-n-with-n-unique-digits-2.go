package main

import (
    "fmt"
    "math/big"
    "time"
)

const maxBase = 28

// etc

func main() {
    start := time.Now()
    var n, k, b, t, nn big.Int
    n.SetUint64(2)
    k.SetUint64(1)
    b.SetUint64(2)
    for base := 2; ; n.Add(&n, &k) {
       if base > 2 && t.Rem(&n, &b).Cmp(bigZero) == 0 {
            continue
        }
        sq := nn.Mul(&n, &n).Text(base)
        if !containsAll(sq, base) {
            continue
        }
        ns := n.Text(base)
        tt := time.Since(start).Seconds()
        fmt.Printf("Base %2d:%15s² = %-28s in %8.3fs\n", base, ns, sq, tt)
        if base == maxBase {
            break
        }
        base++
        b.SetUint64(uint64(base))
        ms, inc, bdr := minStart(base)
        k.SetUint64(inc)
        nn.SetString(ms, base)
        n.Sqrt(&nn)
        t.Add(&n, bigOne)
        if n.Cmp(&t) == -1 {
            n.Set(&t)
        }
        if inc != 1 {
            for {
                nn.Mul(&n, &n)
                dr := digitalRoot(&nn, base)
                if dr == bdr {
                    n.Sub(&n, &k)
                    break
                }
                n.Add(&n, bigOne)
            }
        } else {
            n.Sub(&n, &k)
        }
    }
}
