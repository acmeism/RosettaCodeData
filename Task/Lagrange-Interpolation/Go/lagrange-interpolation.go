package main

import (
	"fmt"
	"math"
	"strconv"
)

// A []float64 is used to represent a Polynomial
// with its coefficients reversed compared to the standard mathematical notation.
// For example, the polynomial 3x^2 + 2x + 1 is represented by the array [1, 2, 3].

func add(one, two []float64) []float64 {
	maxLen := len(one)
	if len(two) > maxLen {
		maxLen = len(two)
	}
	
	sum := make([]float64, maxLen)
	for i := 0; i < len(one); i++ {
		sum[i] = one[i]
	}
	for i := 0; i < len(two); i++ {
		sum[i] += two[i]
	}
	return sum
}

func multiply(one, two []float64) []float64 {
	product := make([]float64, len(one)+len(two)-1)
	for i := 0; i < len(one); i++ {
		for j := 0; j < len(two); j++ {
			product[i+j] += one[i] * two[j]
		}
	}
	return product
}

func scalarMultiply(vec []float64, value float64) []float64 {
	result := make([]float64, len(vec))
	for i, v := range vec {
		result[i] = v * value
	}
	return result
}

func scalarDivide(vec []float64, value float64) []float64 {
	return scalarMultiply(vec, 1.0/value)
}

func evaluate(vec []float64, value float64) float64 {
	result := 0.0
	for i := len(vec) - 1; i >= 0; i-- {
		result = result*value + vec[i]
	}
	return result
}

func display(vec []float64) {
	degree := len(vec) - 1
	if degree == 0 {
		fmt.Printf("%.5f\n", vec[0])
		return
	}

	for i := degree; i >= 0; i-- {
		if vec[i] == 0.0 {
			continue
		}
		var sign string
		if vec[i] < 0.0 && i == degree {
			sign = "-"
		} else if vec[i] < 0.0 {
			sign = " - "
		} else if i < degree {
			sign = " + "
		} else {
			sign = ""
		}
		fmt.Print(sign)
		
		coeff := math.Abs(vec[i])
		if coeff > 1.0 {
			fmt.Printf("%.5f", coeff)
		}
		
		var term string
		if i > 1 {
			term = "x^" + strconv.Itoa(i)
		} else if i == 1 {
			term = "x"
		} else if coeff == 1.0 {
			term = "1"
		} else {
			term = ""
		}
		fmt.Print(term)
	}
	fmt.Println()
}

type Point struct {
	x, y float64
}

func lagrangeInterpolation(points []Point) []float64 {
	polys := make([][]float64, len(points))
	for i := 0; i < len(points); i++ {
		poly := []float64{1.0}
		for j := 0; j < len(points); j++ {
			if i != j {
				poly = multiply(poly, []float64{-points[j].x, 1.0})
			}
		}
		value := evaluate(poly, points[i].x)
		polys[i] = scalarDivide(poly, value)
	}

	sum := []float64{0.0}
	for i := 0; i < len(points); i++ {
		polys[i] = scalarMultiply(polys[i], points[i].y)
		sum = add(sum, polys[i])
	}
	return sum
}

func main() {
	points := []Point{
		{1, 1},
		{2, 4},
		{3, 1},
		{4, 5},
	}

	display(lagrangeInterpolation(points))
}
