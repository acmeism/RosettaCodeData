package main

import (
	"fmt"
	"math"
)

func main() {
	example := func(x float64) float64 { return x*x*x - 3*x*x + 2*x }
	findroots(example, -.5, 2.6, 1)
}

func findroots(f func(float64) float64, lower, upper, step float64) {
	for x0, x1 := lower, lower+step; x0 < upper; x0, x1 = x1, x1+step {
		x1 = math.Min(x1, upper)
		r, status := secant(f, x0, x1)
		if status != "" && r >= x0 && r < x1 {
			fmt.Printf("  %6.3f %s\n", r, status)
		}
	}
}

func secant(f func(float64) float64, x0, x1 float64) (float64, string) {
	var f0 float64
	f1 := f(x0)
	for i := 0; i < 100; i++ {
		f0, f1 = f1, f(x1)
		switch {
		case f1 == 0:
			return x1, "exact"
		case math.Abs(x1-x0) < 1e-6:
			return x1, "approximate"
		}
		x0, x1 = x1, x1-f1*(x1-x0)/(f1-f0)
	}
	return 0, ""
}
