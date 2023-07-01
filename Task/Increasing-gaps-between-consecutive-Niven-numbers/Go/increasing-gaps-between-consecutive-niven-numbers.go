package main

import "fmt"

type is func() uint64

func newSum() is {
    var ms is
    ms = func() uint64 {
        ms = newSum()
        return ms()
    }
    var msd, d uint64
    return func() uint64 {
        if d < 9 {
            d++
        } else {
            d = 0
            msd = ms()
        }
        return msd + d
    }
}

func newHarshard() is {
    i := uint64(0)
    sum := newSum()
    return func() uint64 {
        for i++; i%sum() != 0; i++ {
        }
        return i
    }
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
    fmt.Println("Gap    Index of gap   Starting Niven")
    fmt.Println("===   =============   ==============")
    h := newHarshard()
    pg := uint64(0) // previous highest gap
    pn := h()       // previous Niven number
    for i, n := uint64(1), h(); n <= 20e9; i, n = i+1, h() {
        g := n - pn
        if g > pg {
            fmt.Printf("%3d   %13s   %14s\n", g, commatize(i), commatize(pn))
            pg = g
        }
        pn = n
    }
}
