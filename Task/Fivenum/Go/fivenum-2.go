package main

import (
    "fmt"
    "math/rand"
)

func fivenum(a []float64) (n [5]float64) {
    last := len(a) - 1
    m := last / 2
    n[2] = qsel(a, m)
    q1 := len(a) / 4
    n[1] = qsel(a[:m], q1)
    n[0] = qsel(a[:q1], 0)
    a = a[m:]
    q3 := last - m - q1
    n[3] = qsel(a, q3)
    a = a[q3:]
    n[4] = qsel(a, len(a)-1)
    return
}

func qsel(a []float64, k int) float64 {
    for len(a) > 1 {
        px := rand.Intn(len(a))
        pv := a[px]
        last := len(a) - 1
        a[px], a[last] = a[last], pv
        px = 0
        for i, v := range a[:last] {
            if v < pv {
                a[px], a[i] = v, a[px]
                px++
            }
        }
        a[px], a[last] = pv, a[px]
        if px == k {
            return pv
        }
        if k < px {
            a = a[:px]
        } else {
            a = a[px+1:]
            k -= px + 1
        }
    }
    return a[0]
}

var (
    x1 = []float64{36, 40, 7, 39, 41, 15}
    x2 = []float64{15, 6, 42, 41, 7, 36, 49, 40, 39, 47, 43}
    x3 = []float64{
        0.14082834, 0.09748790, 1.73131507, 0.87636009, -1.95059594,
        0.73438555, -0.03035726, 1.46675970, -0.74621349, -0.72588772,
        0.63905160, 0.61501527, -0.98983780, -1.00447874, -0.62759469,
        0.66206163, 1.04312009, -0.10305385, 0.75775634, 0.32566578,
    }
)

func main() {
    fmt.Println(fivenum(x1))
    fmt.Println(fivenum(x2))
    fmt.Println(fivenum(x3))
}
