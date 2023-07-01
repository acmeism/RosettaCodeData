package main

import (
    "fmt"
    "math"
)

// specification for an integration
type spec struct {
    lower, upper float64               // bounds for integration
    n            int                   // number of parts
    exact        float64               // expected answer
    fs           string                // mathematical description of function
    f            func(float64) float64 // function to integrate
}

// test cases per task description
var data = []spec{
    spec{0, 1, 100, .25, "x^3", func(x float64) float64 { return x * x * x }},
    spec{1, 100, 1000, float64(math.Log(100)), "1/x",
        func(x float64) float64 { return 1 / x }},
    spec{0, 5000, 5e5, 12.5e6, "x", func(x float64) float64 { return x }},
    spec{0, 6000, 6e6, 18e6, "x", func(x float64) float64 { return x }},
}

// object for associating a printable function name with an integration method
type method struct {
    name      string
    integrate func(spec) float64
}

// integration methods implemented per task description
var methods = []method{
    method{"Rectangular (left)    ", rectLeft},
    method{"Rectangular (right)   ", rectRight},
    method{"Rectangular (midpoint)", rectMid},
    method{"Trapezium             ", trap},
    method{"Simpson's             ", simpson},
}

func rectLeft(t spec) float64 {
    var a adder
    r := t.upper - t.lower
    nf := float64(t.n)
    x0 := t.lower
    for i := 0; i < t.n; i++ {
        x1 := t.lower + float64(i+1)*r/nf
        // x1-x0 better than r/nf.
        // (with r/nf, the represenation error accumulates)
        a.add(t.f(x0) * (x1 - x0))
        x0 = x1
    }
    return a.total()
}

func rectRight(t spec) float64 {
    var a adder
    r := t.upper - t.lower
    nf := float64(t.n)
    x0 := t.lower
    for i := 0; i < t.n; i++ {
        x1 := t.lower + float64(i+1)*r/nf
        a.add(t.f(x1) * (x1 - x0))
        x0 = x1
    }
    return a.total()
}

func rectMid(t spec) float64 {
    var a adder
    r := t.upper - t.lower
    nf := float64(t.n)
    // there's a tiny gloss in the x1-x0 trick here.  the correct way
    // would be to compute x's at division boundaries, but we don't need
    // those x's for anything else.  (the function is evaluated on x's
    // at division midpoints rather than division boundaries.)  so, we
    // reuse the midpoint x's, knowing that they will average out just
    // as well.  we just need one extra point, so we use lower-.5.
    x0 := t.lower - .5*r/nf
    for i := 0; i < t.n; i++ {
        x1 := t.lower + (float64(i)+.5)*r/nf
        a.add(t.f(x1) * (x1 - x0))
        x0 = x1
    }
    return a.total()
}

func trap(t spec) float64 {
    var a adder
    r := t.upper - t.lower
    nf := float64(t.n)
    x0 := t.lower
    f0 := t.f(x0)
    for i := 0; i < t.n; i++ {
        x1 := t.lower + float64(i+1)*r/nf
        f1 := t.f(x1)
        a.add((f0 + f1) * .5 * (x1 - x0))
        x0, f0 = x1, f1
    }
    return a.total()
}

func simpson(t spec) float64 {
    var a adder
    r := t.upper - t.lower
    nf := float64(t.n)
    // similar to the rectangle midpoint logic explained above,
    // we play a little loose with the values used for dx and dx0.
    dx0 := r / nf
    a.add(t.f(t.lower) * dx0)
    a.add(t.f(t.lower+dx0*.5) * dx0 * 4)
    x0 := t.lower + dx0
    for i := 1; i < t.n; i++ {
        x1 := t.lower + float64(i+1)*r/nf
        xmid := (x0 + x1) * .5
        dx := x1 - x0
        a.add(t.f(x0) * dx * 2)
        a.add(t.f(xmid) * dx * 4)
        x0 = x1
    }
    a.add(t.f(t.upper) * dx0)
    return a.total() / 6
}

func sum(v []float64) float64 {
    var a adder
    for _, e := range v {
        a.add(e)
    }
    return a.total()
}

type adder struct {
    sum, e float64
}

func (a *adder) total() float64 {
    return a.sum + a.e
}

func (a *adder) add(x float64) {
    sum := a.sum + x
    e := sum - a.sum
    a.e += a.sum - (sum - e) + (x - e)
    a.sum = sum
}

func main() {
    for _, t := range data {
        fmt.Println("Test case: f(x) =", t.fs)
        fmt.Println("Integration from", t.lower, "to", t.upper,
            "in", t.n, "parts")
        fmt.Printf("Exact result            %.7e     Error\n", t.exact)
        for _, m := range methods {
            a := m.integrate(t)
            e := a - t.exact
            if e < 0 {
                e = -e
            }
            fmt.Printf("%s  %.7e  %.7e\n", m.name, a, e)
        }
        fmt.Println("")
    }
}
