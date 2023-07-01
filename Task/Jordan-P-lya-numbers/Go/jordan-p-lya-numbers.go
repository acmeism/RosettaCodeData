package main

import (
    "fmt"
    "rcu"
    "sort"
)

var factorials = make([]uint64, 19)

func cacheFactorials() {
    factorials[0] = 1
    for i := uint64(1); i < 19; i++ {
        factorials[i] = factorials[i-1] * i
    }
}

func jordan_polya(limit uint64) []uint64 {
    ix := sort.Search(19, func(i int) bool { return factorials[i] >= limit })
    if ix > 18 {
        ix = 18
    }
    var res []uint64
    res = append(res, factorials[0:ix+1]...)
    k := 2
    for k < len(res) {
        rk := res[k]
        for l := 2; l < len(res); l++ {
            t := res[l]
            if t > limit/rk {
                break
            }
            kl := t * rk
            for {
                p := sort.Search(len(res), func(i int) bool { return res[i] >= kl })
                if p < len(res) && res[p] != kl {
                    res = append(res[0:p+1], res[p:]...)
                    res[p] = kl
                } else if p == len(res) {
                    res = append(res, kl)
                }
                if kl > limit/rk {
                    break
                }
                kl *= rk
            }
        }
        k++
    }
    return res[1:]
}

func decompose(n uint64, start int) []uint64 {
    for s := uint64(start); s > 0; s-- {
        var f []uint64
        if s < 2 {
            return f
        }
        m := n
        for m%factorials[s] == 0 {
            f = append(f, s)
            m /= factorials[s]
            if m == 1 {
                return f
            }
        }
        if len(f) > 0 {
            g := decompose(m, int(s-1))
            if len(g) > 0 {
                prod := uint64(1)
                for _, e := range g {
                    prod *= factorials[e]
                }
                if prod == m {
                    return append(f, g...)
                }
            }
        }
    }
    return []uint64{}
}

func superscript(n int) string {
    ss := []string{"⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"}
    if n < 10 {
        return ss[n]
    }
    return ss[n/10] + ss[n%10]
}

func main() {
    cacheFactorials()
    v := jordan_polya(uint64(1) << 53)
    fmt.Println("First 50 Jordan-Pólya numbers:")
    for i := 0; i < 50; i++ {
        fmt.Printf("%4d ", v[i])
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }
    fmt.Printf("\nThe largest Jordan-Pólya number before 100 million: ")
    ix := sort.Search(len(v), func(i int) bool { return v[i] >= 100_000_000 })
    fmt.Println(rcu.Commatize(v[ix-1]))
    fmt.Println()
    for _, e := range []uint64{800, 1050, 1800, 2800, 3800} {
        fmt.Printf("The %sth Jordan-Pólya number is : %s\n", rcu.Commatize(e), rcu.Commatize(v[e-1]))
        w := decompose(v[e-1], 18)
        count := 1
        t := w[0]
        fmt.Printf(" = ")
        for j := 1; j < len(w); j++ {
            u := w[j]
            if u != t {
                if count == 1 {
                    fmt.Printf("%d! x ", t)
                } else {
                    fmt.Printf("(%d!)%s x ", t, superscript(count))
                    count = 1
                }
                t = u
            } else {
                count++
            }
        }
        if count == 1 {
            fmt.Printf("%d! x ", t)
        } else {
            fmt.Printf("(%d!)%s x ", t, superscript(count))
        }
        fmt.Printf("\b\b \n\n")
    }
}
