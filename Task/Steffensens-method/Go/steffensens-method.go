package main

import (
    "fmt"
    "math"
)

type fun = func(float64) float64

func aitken(f fun, p0 float64) float64 {
    p1 := f(p0)
    p2 := f(p1)
    p1m0 := p1 - p0
    return p0 - p1m0*p1m0/(p2-2.0*p1+p0)
}

func steffensenAitken(f fun, pinit, tol float64, maxiter int) float64 {
    p0 := pinit
    p := aitken(f, p0)
    iter := 1
    for math.Abs(p-p0) > tol && iter < maxiter {
        p0 = p
        p = aitken(f, p0)
        iter++
    }
    if math.Abs(p-p0) > tol {
        return math.NaN()
    }
    return p
}

func deCasteljau(c0, c1, c2, t float64) float64 {
    s := 1.0 - t
    c01 := s*c0 + t*c1
    c12 := s*c1 + t*c2
    return s*c01 + t*c12
}

func xConvexLeftParabola(t float64) float64 {
    return deCasteljau(2.0, -8.0, 2.0, t)
}

func yConvexRightParabola(t float64) float64 {
    return deCasteljau(1.0, 2.0, 3.0, t)
}

func implicitEquation(x, y float64) float64 {
    return 5.0*x*x + y - 5.0
}

func f(t float64) float64 {
    x := xConvexLeftParabola(t)
    y := yConvexRightParabola(t)
    return implicitEquation(x, y) + t
}

func main() {
    t0 := 0.0
    for i := 0; i < 11; i++ {
        fmt.Printf("t0 = %0.1f : ", t0)
        t := steffensenAitken(f, t0, 0.00000001, 1000)
        if math.IsNaN(t) {
            fmt.Println("no answer")
        } else {
            x := xConvexLeftParabola(t)
            y := yConvexRightParabola(t)
            if math.Abs(implicitEquation(x, y)) <= 0.000001 {
                fmt.Printf("intersection at (%f, %f)\n", x, y)
            } else {
                fmt.Println("spurious solution")
            }
        }
        t0 += 0.1
    }
}
