package main

import "fmt"

type rangeBounds struct {
    b1, b2 float64
}

func newRangeMap(xr, yr rangeBounds) func(float64) (float64, bool) {
    // normalize direction of ranges so that out-of-range test works
    if xr.b1 > xr.b2 {
        xr.b1, xr.b2 = xr.b2, xr.b1
        yr.b1, yr.b2 = yr.b2, yr.b1
    }
    // compute slope, intercept
    m := (yr.b2 - yr.b1) / (xr.b2 - xr.b1)
    b := yr.b1 - m*xr.b1
    // return function literal
    return func(x float64) (y float64, ok bool) {
        if x < xr.b1 || x > xr.b2 {
            return 0, false // out of range
        }
        return m*x + b, true
    }
}

func main() {
    rm := newRangeMap(rangeBounds{0, 10}, rangeBounds{-1, 0})
    for s := float64(-2); s <= 12; s += 2 {
        t, ok := rm(s)
        if ok {
            fmt.Printf("s: %5.2f  t: %5.2f\n", s, t)
        } else {
            fmt.Printf("s: %5.2f  out of range\n", s)
        }
    }
}
