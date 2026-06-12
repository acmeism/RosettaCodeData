package main

import (
    "fmt"
    "math"
)

func steepestDescent(x []float64, alpha, tolerance float64) {
    n := len(x)
    g0 := g(x) // Initial estimate of result.

    // Calculate initial gradient.
    fi := gradG(x)

    // Calculate initial norm.
    delG := 0.0
    for i := 0; i < n; i++ {
        delG += fi[i] * fi[i]
    }
    delG = math.Sqrt(delG)
    b := alpha / delG

    // Iterate until value is <= tolerance.
    for delG > tolerance {
        // Calculate next value.
        for i := 0; i < n; i++ {
            x[i] -= b * fi[i]
        }

        // Calculate next gradient.
        fi = gradG(x)

        // Calculate next norm.
        delG = 0
        for i := 0; i < n; i++ {
            delG += fi[i] * fi[i]
        }
        delG = math.Sqrt(delG)
        b = alpha / delG

        // Calculate next value.
        g1 := g(x)

        // Adjust parameter.
        if g1 > g0 {
            alpha /= 2
        } else {
            g0 = g1
        }
    }
}

// Provides a rough calculation of gradient g(p).
func gradG(p []float64) []float64 {
    z := make([]float64, len(p))
    x := p[0]
    y := p[1]
    z[0] = 2*(x-1)*math.Exp(-y*y) - 4*x*math.Exp(-2*x*x)*y*(y+2)
    z[1] = -2*(x-1)*(x-1)*y*math.Exp(-y*y) + math.Exp(-2*x*x)*(y+2) + math.Exp(-2*x*x)*y
    return z
}

// Function for which minimum is to be found.
func g(x []float64) float64 {
    return (x[0]-1)*(x[0]-1)*
        math.Exp(-x[1]*x[1]) + x[1]*(x[1]+2)*
        math.Exp(-2*x[0]*x[0])
}

func main() {
    tolerance := 0.0000006
    alpha := 0.1
    x := []float64{0.1, -1} // Initial guess of location of minimum.

    steepestDescent(x, alpha, tolerance)
    fmt.Println("Testing steepest descent method:")
    fmt.Printf("The minimum is at x = %f, y = %f for which f(x, y) = %f.\n", x[0], x[1], g(x))
}
