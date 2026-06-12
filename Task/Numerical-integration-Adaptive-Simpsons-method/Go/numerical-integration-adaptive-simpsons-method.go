package main

import (
    "fmt"
    "math"
)

type F = func(float64) float64

/* "structured" adaptive version, translated from Racket */
func quadSimpsonsMem(f F, a, fa, b, fb float64) (m, fm, simp float64) {
    // Evaluates Simpson's Rule, also returning m and f(m) to reuse.
    m = (a + b) / 2
    fm = f(m)
    simp = math.Abs(b-a) / 6 * (fa + 4*fm + fb)
    return
}

func quadAsrRec(f F, a, fa, b, fb, eps, whole, m, fm float64) float64 {
    // Efficient recursive implementation of adaptive Simpson's rule.
    // Function values at the start, middle, end of the intervals are retained.
    lm, flm, left := quadSimpsonsMem(f, a, fa, m, fm)
    rm, frm, right := quadSimpsonsMem(f, m, fm, b, fb)
    delta := left + right - whole
    if math.Abs(delta) <= eps*15 {
        return left + right + delta/15
    }
    return quadAsrRec(f, a, fa, m, fm, eps/2, left, lm, flm) +
        quadAsrRec(f, m, fm, b, fb, eps/2, right, rm, frm)
}

func quadAsr(f F, a, b, eps float64) float64 {
    // Integrate f from a to b using ASR with max error of eps.
    fa, fb := f(a), f(b)
    m, fm, whole := quadSimpsonsMem(f, a, fa, b, fb)
    return quadAsrRec(f, a, fa, b, fb, eps, whole, m, fm)
}

func main() {
    a, b := 0.0, 1.0
    sinx := quadAsr(math.Sin, a, b, 1e-09)
    fmt.Printf("Simpson's integration of sine from %g to %g = %f\n", a, b, sinx)
}
