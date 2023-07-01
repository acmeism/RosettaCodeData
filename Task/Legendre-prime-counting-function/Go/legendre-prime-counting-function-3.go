package main

import (
    "fmt"
    "math"
    "time"
)

var masks = [8]uint8{1, 2, 4, 8, 16, 32, 64, 128}

func half(n int) int { return (n - 1) >> 1 }

func divide(nm, d uint64) int { return int(float64(nm) / float64(d)) }

func countPrimes(n uint64) int64 {
    if n < 9 {
        if n < 2 {
            return 0
        } else {
            return (int64(n) + 1) / 2
        }
    }
    rtlmt := int(math.Sqrt(float64(n)))
    mxndx := (rtlmt - 1) / 2
    arrlen := mxndx + 1
    smalls := make([]uint32, arrlen)
    roughs := make([]uint32, arrlen)
    larges := make([]int64, arrlen)
    for i := uint32(0); i < uint32(arrlen); i++ {
        smalls[i] = i
        roughs[i] = i + i + 1
        larges[i] = int64((n/uint64(i+i+1) - 1) / 2)
    }
    cullbuflen := (mxndx + 8) / 8
    cullbuf := make([]uint8, cullbuflen)
    nbps := 0
    rilmt := arrlen
    for i := 1; ; i++ {
        sqri := (i + i) * (i + 1)
        if sqri > mxndx {
            break
        }
        if (cullbuf[i>>3] & masks[i&7]) != 0 {
            continue
        }
        cullbuf[i>>3] |= masks[i&7]
        bp := i + i + 1
        for c := sqri; c < arrlen; c += bp {
            cullbuf[c>>3] |= masks[c&7]
        }
        nri := 0
        for ori := 0; ori < rilmt; ori++ {
            r := int(roughs[ori])
            rci := r >> 1
            if (cullbuf[rci>>3] & masks[rci&7]) != 0 {
                continue
            }
            d := r * bp
            t := int64(0)
            if d <= rtlmt {
                t = larges[int(smalls[d>>1])-nbps]
            } else {
                t = int64(smalls[half(divide(n, uint64(d)))])
            }
            larges[nri] = larges[ori] - t + int64(nbps)
            roughs[nri] = uint32(r)
            nri++
        }
        si := mxndx
        for pm := (rtlmt/bp - 1) | 1; pm >= bp; pm -= 2 {
            c := smalls[pm>>1]
            e := (pm * bp) >> 1
            for ; si >= e; si-- {
                smalls[si] -= (c - uint32(nbps))
            }
        }
        rilmt = nri
        nbps++
    }
    ans := larges[0] + int64(((rilmt + 2*(nbps-1)) * (rilmt - 1) / 2))
    for ri := 1; ri < rilmt; ri++ {
        ans -= larges[ri]
    }
    for ri := 1; ; ri++ {
        p := uint64(roughs[ri])
        m := n / p
        ei := int(smalls[half(int(m/p))]) - nbps
        if ei <= ri {
            break
        }
        ans -= int64((ei - ri) * (nbps + ri - 1))
        for sri := ri + 1; sri < ei+1; sri++ {
            ans += int64(smalls[half(divide(m, uint64(roughs[sri])))])
        }
    }
    return ans + 1
}

func main() {
    start := time.Now()
    for i, n := uint64(0), uint64(1); i <= 9; i, n = i+1, n*10 {
        fmt.Printf("10^%d  %d\n", i, countPrimes(n))
    }
    elapsed := time.Since(start).Microseconds()
    fmt.Printf("\nTook %d microseconds\n", elapsed)
}
