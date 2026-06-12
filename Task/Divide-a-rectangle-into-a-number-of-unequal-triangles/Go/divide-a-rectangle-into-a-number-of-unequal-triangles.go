package main

import (
	"fmt"
	"math/rand"
	"sort"
)

// Point represents a 2D point with x and y coordinates
type Point struct {
	X, Y float64
}

// Triangle represents a triangle with three points
type Triangle [3]Point

// RectIntoTri divides a rectangle into triangles
func RectIntoTri(topRight Point, triangles int, randTol float64) []Triangle {
	width, height := topRight.X, topRight.Y
	
	if triangles <= 2 || triangles%2 == 0 {
		panic("Needs Odd number greater than 2")
	}

	insertTop := triangles / 2
	var p, q []float64
	
	// Generate random points until we have different distances
	for p == nil || !differentDistances(p, q, height) {
		p = append([]float64{0}, randPoints(insertTop, width, int(randTol))...)
		p = append(p, width)
		
		q = append([]float64{0}, randPoints(insertTop-1, width, int(randTol))...)
		q = append(q, width)
	}

	// Triangle extraction
	var result []Triangle
	
	// Top triangles
	for i := 0; i < len(p)-1; i++ {
		result = append(result, Triangle{
			Point{p[i], height},
			Point{p[i+1], height},
			Point{q[i], 0},
		})
	}
	
	// Bottom triangles
	for i := 0; i < len(q)-1; i++ {
		result = append(result, Triangle{
			Point{q[i], 0},
			Point{q[i+1], 0},
			Point{p[i+1], height},
		})
	}

	return result
}

// RectIntoTopTri divides a rectangle into triangles along the top
func RectIntoTopTri(topRight Point, triangles int, randTol float64) []Triangle {
	width, height := topRight.X, topRight.Y
	
	if triangles <= 2 {
		panic("Needs int > 2")
	}

	insertTop := triangles - 2
	top := append([]float64{0}, randPoints(insertTop, width, int(randTol))...)
	top = append(top, width)

	var result []Triangle
	
	// Top triangles
	for i := 0; i < len(top)-1; i++ {
		result = append(result, Triangle{
			Point{0, 0},
			Point{top[i], height},
			Point{top[i+1], height},
		})
	}
	
	// Bottom triangle
	result = append(result, Triangle{
		Point{0, 0},
		Point{width, height},
		Point{width, 0},
	})

	return result
}

// RandPoints returns n sorted random points between 0 and width
func randPoints(n int, width float64, randTol int) []float64 {
	if n <= 0 {
		return []float64{}
	}
	
	// Generate n random numbers
	nums := make([]int, randTol-1)
	for i := 0; i < randTol-1; i++ {
		nums[i] = i + 1
	}
	
	// Shuffle and take n
	rand.Shuffle(len(nums), func(i, j int) {
		nums[i], nums[j] = nums[j], nums[i]
	})
	
	// Convert to floats
	result := make([]float64, n)
	for i := 0; i < n; i++ {
		result[i] = float64(nums[i]) * width / float64(randTol)
	}
	
	// Sort
	sort.Float64s(result)
	return result
}

// DifferentDistances checks if all point-to-next-point distances are different
func differentDistances(p, q []float64, height float64) bool {
	var diffs []float64
	
	// Add distances between consecutive points in p
	for i := 0; i < len(p)-1; i++ {
		diffs = append(diffs, p[i+1]-p[i])
	}
	
	// Add distances between consecutive points in q
	for i := 0; i < len(q)-1; i++ {
		diffs = append(diffs, q[i+1]-q[i])
	}
	
	// Add height
	diffs = append(diffs, height)
	
	// Check if all distances are different
	return len(diffs) == len(uniqueFloats(diffs))
}

// UniqueFloats returns unique elements from a slice of floats
func uniqueFloats(s []float64) []float64 {
	seen := make(map[float64]struct{})
	var result []float64
	
	for _, v := range s {
		if _, ok := seen[v]; !ok {
			seen[v] = struct{}{}
			result = append(result, v)
		}
	}
	
	return result
}

func main() {
	fmt.Println("\nrect_into_tri #1")
	printTriangles(RectIntoTri(Point{2, 1}, 5, 10))
	
	fmt.Println("\nrect_into_tri #2")
	printTriangles(RectIntoTri(Point{2, 1}, 5, 10))
	
	fmt.Println("\nrect_into_top_tri #1")
	printTriangles(RectIntoTopTri(Point{2, 1}, 4, 10))
	
	fmt.Println("\nrect_into_top_tri #2")
	printTriangles(RectIntoTopTri(Point{2, 1}, 4, 10))
}

// PrintTriangles pretty prints a slice of triangles
func printTriangles(triangles []Triangle) {
	for i, t := range triangles {
		fmt.Printf("%d: {(%g, %g), (%g, %g), (%g, %g)}\n",
			i, t[0].X, t[0].Y, t[1].X, t[1].Y, t[2].X, t[2].Y)
	}
}
