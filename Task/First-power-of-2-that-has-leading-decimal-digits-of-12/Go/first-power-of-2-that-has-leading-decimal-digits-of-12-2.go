package main

import (
    "fmt"
    "strconv"
    "time"
)

func p(L, n uint64) uint64 {
    Ls := strconv.FormatUint(L, 10)
    digits := uint64(1)
    for d := 1; d <= 18-len(Ls); d++ {
        digits *= 10
    }
    const ten18 uint64 = 1e18
    var count, i, probe uint64 = 0, 0, 1
    for {
        probe += probe
        i++
        if probe >= ten18 {
            for {
                if probe >= ten18 {
                    probe /= 10
                }
                if probe/digits == L {
                    count++
                    if count >= n {
                        count--
                        break
                    }
                }
                probe += probe
                i++
            }
        }
        ps := strconv.FormatUint(probe, 10)
        le := len(Ls)
        if le > len(ps) {
            le = len(ps)
        }
        if ps[0:le] == Ls {
            count++
            if count >= n {
                break
            }
        }
    }
    return i
}

func commatize(n uint64) string {
    s := fmt.Sprintf("%d", n)
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    return s
}

func main() {
    start := time.Now()
    params := [][2]uint64{{12, 1}, {12, 2}, {123, 45}, {123, 12345}, {123, 678910}}
    for _, param := range params {
        fmt.Printf("p(%d, %d) = %s\n", param[0], param[1], commatize(p(param[0], param[1])))
    }
    fmt.Printf("\nTook %s\n", time.Since(start))
}
