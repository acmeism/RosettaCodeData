package main

import (
    "fmt"
    "math"
)

type cheb struct {
    c        []float64
    min, max float64
}

func main() {
    fn := math.Cos
    c := newCheb(0, 1, 10, 10, fn)
    fmt.Println("coefficients:")
    for _, c := range c.c {
        fmt.Printf("% .15f\n", c)
    }
    fmt.Println("\nx     computed    approximated    computed-approx")
    const n = 10
    for i := 0.; i <= n; i++ {
        x := (c.min*(n-i) + c.max*i) / n
        computed := fn(x)
        approx := c.eval(x)
        fmt.Printf("%.1f %12.8f  %12.8f   % .3e\n",
            x, computed, approx, computed-approx)
    }
}

func newCheb(min, max float64, nCoeff, nNodes int, fn func(float64) float64) *cheb {
    c := &cheb{
        c:   make([]float64, nCoeff),
        min: min,
        max: max,
    }
    f := make([]float64, nNodes)
    p := make([]float64, nNodes)
    z := .5 * (max + min)
    r := .5 * (max - min)
    for k := 0; k < nNodes; k++ {
        p[k] = math.Pi * (float64(k) + .5) / float64(nNodes)
        f[k] = fn(z + math.Cos(p[k])*r)
    }
    n2 := 2 / float64(nNodes)
    for j := 0; j < nCoeff; j++ {
        sum := 0.
        for k := 0; k < nNodes; k++ {
            sum += f[k] * math.Cos(float64(j)*p[k])
        }
        c.c[j] = sum * n2
    }
    return c
}

func (c *cheb) eval(x float64) float64 {
    x1 := (2*x - c.min - c.max) / (c.max - c.min)
    x2 := 2 * x1
    var s, t float64
    for j := len(c.c) - 1; j >= 1; j-- {
        t, s = x2*t-s+c.c[j], t
    }
    return x1*t - s + .5*c.c[0]
}
