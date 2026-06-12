package main

import (
	"fmt"
	"math"
	"math/cmplx"
)

func circleFromThreePoints(z1 complex128, z2 complex128, z3 complex128) (complex128, float64, error) {
	if z1 == z2 || z2 == z3 || z3 == z1 {
		return -1, -1, fmt.Errorf("Duplicate points: %v, %v, %v", z1, z2, z3)
	}

	w := (z3 - z1) / (z2 - z1)

	if math.Abs(imag(w)) <= 0 {
		return -1, -1, fmt.Errorf("Points are collinear: %v, %v, %v", z1, z2, z3)
	}

	c := (z2-z1)*(w-complex(cmplx.Abs(w)*cmplx.Abs(w), 0))/(complex(0, 2*imag(w))) + z1
	r := cmplx.Abs(z1 - c)

	return c, r, nil
}

func main() {
	center, radius, err := circleFromThreePoints(22.83+2.07i, 14.39+30.24i, 33.65+17.31i)

	if err != nil {
		panic(err)
	}

	fmt.Printf("centerpoint: (%.2f, %.2f)\n", real(center), imag(center))
	fmt.Printf("radius: %.2f\n", radius)
}
