package main

import (
    "fmt"
    "math"
    "strconv"
    "strings"
)

func d2d(d float64) float64 { return math.Mod(d, 360) }

func g2g(g float64) float64 { return math.Mod(g, 400) }

func m2m(m float64) float64 { return math.Mod(m, 6400) }

func r2r(r float64) float64 { return math.Mod(r, 2*math.Pi) }

func d2g(d float64) float64 { return d2d(d) * 400 / 360 }

func d2m(d float64) float64 { return d2d(d) * 6400 / 360 }

func d2r(d float64) float64 { return d2d(d) * math.Pi / 180 }

func g2d(g float64) float64 { return g2g(g) * 360 / 400 }

func g2m(g float64) float64 { return g2g(g) * 6400 / 400 }

func g2r(g float64) float64 { return g2g(g) * math.Pi / 200 }

func m2d(m float64) float64 { return m2m(m) * 360 / 6400 }

func m2g(m float64) float64 { return m2m(m) * 400 / 6400 }

func m2r(m float64) float64 { return m2m(m) * math.Pi / 3200 }

func r2d(r float64) float64 { return r2r(r) * 180 / math.Pi }

func r2g(r float64) float64 { return r2r(r) * 200 / math.Pi }

func r2m(r float64) float64 { return r2r(r) * 3200 / math.Pi }

// Aligns number to decimal point assuming 7 characters before and after.
func s(f float64) string {
    wf := strings.Split(strconv.FormatFloat(f, 'g', 15, 64), ".")
    if len(wf) == 1 {
        return fmt.Sprintf("%7s        ", wf[0])
    }
    le := len(wf[1])
    if le > 7 {
        le = 7
    }
    return fmt.Sprintf("%7s.%-7s", wf[0], wf[1][:le])
}

func main() {
    angles := []float64{-2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795,
        359, 399, 6399, 1000000}
    ft := "%s %s %s %s %s\n"
    fmt.Printf(ft, "    degrees    ", "normalized degs", "    gradians   ", "     mils      ", "     radians")
    for _, a := range angles {
        fmt.Printf(ft, s(a), s(d2d(a)), s(d2g(a)), s(d2m(a)), s(d2r(a)))
    }
    fmt.Printf(ft, "\n   gradians    ", "normalized grds", "    degrees    ", "     mils      ", "     radians")
    for _, a := range angles {
        fmt.Printf(ft, s(a), s(g2g(a)), s(g2d(a)), s(g2m(a)), s(g2r(a)))
    }
    fmt.Printf(ft, "\n     mils      ", "normalized mils", "    degrees    ", "   gradians    ", "     radians")
    for _, a := range angles {
        fmt.Printf(ft, s(a), s(m2m(a)), s(m2d(a)), s(m2g(a)), s(m2r(a)))
    }
    fmt.Printf(ft, "\n    radians    ", "normalized rads", "    degrees    ", "   gradians    ", "      mils  ")
    for _, a := range angles {
        fmt.Printf(ft, s(a), s(r2r(a)), s(r2d(a)), s(r2g(a)), s(r2m(a)))
    }
}
