package main

import (
    "fmt"
    "math"
    "sort"
    "time"
)

type (
    z1 func() z2
    z2 struct {
        value    int64
        hasValue bool
    }
)

var pow10 [19]int64

func init() {
    pow10[0] = 1
    for i := 1; i < 19; i++ {
        pow10[i] = 10 * pow10[i-1]
    }
}

func izRev(n int, i, g uint64) bool {
    if i/uint64(pow10[n-1]) != g%10 {
        return false
    }
    if n < 2 {
        return true
    }
    return izRev(n-1, i%uint64(pow10[n-1]), g/10)
}

func fG(n z1, start, end, reset int, step int64, l *int64) z1 {
    i, g, e := step*int64(start), step*int64(end), step*int64(reset)
    return func() z2 {
        for i < g {
            *l += step
            i += step
            return z2{*l, true}
        }
        i = e
        *l -= (g - e)
        return n()
    }
}

type nLH struct{ even, odd []uint64 }

type zp struct {
    n z1
    g [][2]int64
}

func newNLH(e zp) nLH {
    var even, odd []uint64
    n, g := e.n, e.g
    for i := n(); i.hasValue; i = n() {
        for _, p := range g {
            ng, gg := p[0], p[1]
            if (ng > 0) || (i.value > 0) {
                w := uint64(ng*pow10[4] + gg + i.value)
                ws := uint64(math.Sqrt(float64(w)))
                if ws*ws == w {
                    if w%2 == 0 {
                        even = append(even, w)
                    } else {
                        odd = append(odd, w)
                    }
                }
            }
        }
    }
    return nLH{even, odd}
}

func makeL(n int) zp {
    g := make([]z1, n/2-3)
    g[0] = func() z2 { return z2{} }
    for i := 1; i < n/2-3; i++ {
        s := -9
        if i == n/2-4 {
            s = -10
        }
        l := pow10[n-i-4] - pow10[i+3]
        acc += l * int64(s)
        g[i] = fG(g[i-1], s, 9, -9, l, &acc)
    }
    var g0, g1, g2, g3 int64
    l0, l1, l2, l3 := pow10[n-5], pow10[n-6], pow10[n-7], pow10[n-8]
    f := func() [][2]int64 {
        var w [][2]int64
        for g0 < 7 {
            nn := g3*l3 + g2*l2 + g1*l1 + g0*l0
            gg := -1000*g3 - 100*g2 - 10*g1 - g0
            if g3 < 9 {
                g3++
            } else {
                g3 = -9
                if g2 < 9 {
                    g2++
                } else {
                    g2 = -9
                    if g1 < 9 {
                        g1++
                    } else {
                        g1 = -9
                        if g0 == 1 {
                            g0 = 3
                        }
                        g0++
                    }
                }
            }
            if bs[(pow10[10]+gg)%10000] {
                w = append(w, [2]int64{nn, gg})
            }
        }
        return w
    }
    return zp{g[n/2-4], f()}
}

func makeH(n int) zp {
    acc = -(pow10[n/2] + pow10[(n-1)/2])
    g := make([]z1, (n+1)/2-3)
    g[0] = func() z2 { return z2{} }
    for i := 1; i < n/2-3; i++ {
        j := 0
        if i == (n+1)/2-3 {
            j = -1
        }
        g[i] = fG(g[i-1], j, 18, 0, pow10[n-i-4]+pow10[i+3], &acc)
        if n%2 == 1 {
            g[(n+1)/2-4] = fG(g[n/2-4], -1, 9, 0, 2*pow10[n/2], &acc)
        }
    }
    g0 := int64(4)
    var g1, g2, g3 int64
    l0, l1, l2, l3 := pow10[n-5], pow10[n-6], pow10[n-7], pow10[n-8]
    f := func() [][2]int64 {
        var w [][2]int64
        for g0 < 17 {
            nn := g3*l3 + g2*l2 + g1*l1 + g0*l0
            gg := 1000*g3 + 100*g2 + 10*g1 + g0
            if g3 < 18 {
                g3++
            } else {
                g3 = 0
                if g2 < 18 {
                    g2++
                } else {
                    g2 = 0
                    if g1 < 18 {
                        g1++
                    } else {
                        g1 = 0
                        if g0 == 6 || g0 == 9 {
                            g0 += 3
                        }
                        g0++
                    }
                }
            }
            if bs[gg%10000] {
                w = append(w, [2]int64{nn, gg})
            }
        }
        return w
    }
    return zp{g[(n+1)/2-4], f()}
}

var (
    acc  int64
    bs   = make([]bool, 10000)
    L, H nLH
)

func rare(n int) []uint64 {
    acc = 0
    for g := 0; g < 10000; g++ {
        bs[(g*g)%10000] = true
    }
    L = newNLH(makeL(n))
    H = newNLH(makeH(n))
    var rares []uint64
    for _, l := range L.even {
        for _, h := range H.even {
            r := (h - l) / 2
            z := h - r
            if izRev(n, r, z) {
                rares = append(rares, z)
            }
        }
    }
    for _, l := range L.odd {
        for _, h := range H.odd {
            r := (h - l) / 2
            z := h - r
            if izRev(n, r, z) {
                rares = append(rares, z)
            }
        }
    }
    if len(rares) > 0 {
        sort.Slice(rares, func(i, j int) bool {
            return rares[i] < rares[j]
        })
    }
    return rares
}

// Formats time in form hh:mm:ss.fff (i.e. millisecond precision).
func formatTime(d time.Duration) string {
    f := d.Milliseconds()
    s := f / 1000
    f %= 1000
    m := s / 60
    s %= 60
    h := m / 60
    m %= 60
    return fmt.Sprintf("%02d:%02d:%02d.%03d", h, m, s, f)
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
    bStart := time.Now() // block time
    tStart := bStart     // total time
    nth := 3             // i.e. count of rare numbers < 10 digits
    fmt.Println("nth             rare number    digs  block time    total time")
    for nd := 10; nd <= 19; nd++ {
        rares := rare(nd)
        if len(rares) > 0 {
            for i, r := range rares {
                nth++
                t := ""
                if i < len(rares)-1 {
                    t = "\n"
                }
                fmt.Printf("%2d  %25s%s", nth, commatize(r), t)
            }
        } else {
            fmt.Printf("%29s", "")
        }
        fbTime := formatTime(time.Since(bStart))
        ftTime := formatTime(time.Since(tStart))
        fmt.Printf("  %2d: %s  %s\n", nd, fbTime, ftTime)
        bStart = time.Now() // restart block timing
    }
}
