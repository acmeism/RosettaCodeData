package main

import (
    "fmt"
    "math/big"
    "strconv"
    "time"
)

const maxBase = 27
const minSq36 = "1023456789abcdefghijklmnopqrstuvwxyz"
const minSq36x = "10123456789abcdefghijklmnopqrstuvwxyz"

var bigZero = new(big.Int)
var bigOne = new(big.Int).SetUint64(1)

func containsAll(sq string, base int) bool {
    var found [maxBase]byte
    le := len(sq)
    reps := 0
    for _, r := range sq {
        d := r - 48
        if d > 38 {
            d -= 39
        }
        found[d]++
        if found[d] > 1 {
            reps++
            if le-reps < base {
                return false
            }
        }
    }
    return true
}

func sumDigits(n, base *big.Int) *big.Int {
    q := new(big.Int).Set(n)
    r := new(big.Int)
    sum := new(big.Int).Set(bigZero)
    for q.Cmp(bigZero) == 1 {
        q.QuoRem(q, base, r)
        sum.Add(sum, r)
    }
    return sum
}

func digitalRoot(n *big.Int, base int) int {
    root := new(big.Int)
    b := big.NewInt(int64(base))
    for i := new(big.Int).Set(n); i.Cmp(b) >= 0; i.Set(root) {
        root.Set(sumDigits(i, b))
    }
    return int(root.Int64())
}

func minStart(base int) (string, uint64, int) {
    nn := new(big.Int)
    ms := minSq36[:base]
    nn.SetString(ms, base)
    bdr := digitalRoot(nn, base)
    var drs []int
    var ixs []uint64
    for n := uint64(1); n < uint64(2*base); n++ {
        nn.SetUint64(n * n)
        dr := digitalRoot(nn, base)
        if dr == 0 {
            dr = int(n * n)
        }
        if dr == bdr {
            ixs = append(ixs, n)
        }
        if n < uint64(base) && dr >= bdr {
            drs = append(drs, dr)
        }
    }
    inc := uint64(1)
    if len(ixs) >= 2 && base != 3 {
        inc = ixs[1] - ixs[0]
    }
    if len(drs) == 0 {
        return ms, inc, bdr
    }
    min := drs[0]
    for _, dr := range drs[1:] {
        if dr < min {
            min = dr
        }
    }
    rd := min - bdr
    if rd == 0 {
        return ms, inc, bdr
    }
    if rd == 1 {
        return minSq36x[:base+1], 1, bdr
    }
    ins := string(minSq36[rd])
    return (minSq36[:rd] + ins + minSq36[rd:])[:base+1], inc, bdr
}

func main() {
    start := time.Now()
    var nb, nn big.Int
    for n, k, base := uint64(2), uint64(1), 2; ; n += k {
        if base > 2 && n%uint64(base) == 0 {
            continue
        }
        nb.SetUint64(n)
        sq := nb.Mul(&nb, &nb).Text(base)
        if !containsAll(sq, base) {
            continue
        }
        ns := strconv.FormatUint(n, base)
        tt := time.Since(start).Seconds()
        fmt.Printf("Base %2d:%15s² = %-27s in %8.3fs\n", base, ns, sq, tt)
        if base == maxBase {
            break
        }
        base++
        ms, inc, bdr := minStart(base)
        k = inc
        nn.SetString(ms, base)
        nb.Sqrt(&nn)
        if nb.Uint64() < n+1 {
            nb.SetUint64(n + 1)
        }
        if k != 1 {
            for {
                nn.Mul(&nb, &nb)
                dr := digitalRoot(&nn, base)
                if dr == bdr {
                    n = nb.Uint64() - k
                    break
                }
                nb.Add(&nb, bigOne)
            }
        } else {
            n = nb.Uint64() - k
        }
    }
}
