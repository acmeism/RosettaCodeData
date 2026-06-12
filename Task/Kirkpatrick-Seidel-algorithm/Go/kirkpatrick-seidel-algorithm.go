package main

import (
	"fmt"
	"math"
	"math/rand"
	"time"
)

type Point struct {
	x float64
	y float64
}

func newPoint(x, y float64) Point {
	return Point{x, y}
}

func (p Point) lessThan(other Point) bool {
	if p.x == other.x {
		return p.y < other.y
	}
	return p.x < other.x
}

func (p Point) equals(other Point) bool {
	return p.x == other.x && p.y == other.y
}

func (p Point) notEquals(other Point) bool {
	return !p.equals(other)
}

func flipped(points []Point) []Point {
	result := make([]Point, len(points))
	for i, point := range points {
		result[i] = newPoint(-point.x, -point.y)
	}
	return result
}

func quickselectFloat(ls []float64, index int, lo int, hi int, depth int) float64 {
	if hi == -1 {
		hi = len(ls) - 1
	}

	if lo == hi {
		return ls[lo]
	}

	pivot := lo + rand.Intn(hi-lo+1)
	ls[lo], ls[pivot] = ls[pivot], ls[lo] // swap

	cur := lo
	for run := lo + 1; run <= hi; run++ {
		if ls[run] < ls[lo] {
			cur++
			ls[cur], ls[run] = ls[run], ls[cur] // swap
		}
	}

	ls[cur], ls[lo] = ls[lo], ls[cur] // swap

	if index < cur {
		return quickselectFloat(ls, index, lo, cur-1, depth+1)
	} else if index > cur {
		return quickselectFloat(ls, index, cur+1, hi, depth+1)
	} else {
		return ls[cur]
	}
}

func quickselectPoint(ls []Point, index int, lo int, hi int, depth int) Point {
	if hi == -1 {
		hi = len(ls) - 1
	}

	if lo == hi {
		return ls[lo]
	}

	pivot := lo + rand.Intn(hi-lo+1)
	ls[lo], ls[pivot] = ls[pivot], ls[lo] // swap

	cur := lo
	for run := lo + 1; run <= hi; run++ {
		if ls[run].lessThan(ls[lo]) {
			cur++
			ls[cur], ls[run] = ls[run], ls[cur] // swap
		}
	}

	ls[cur], ls[lo] = ls[lo], ls[cur] // swap

	if index < cur {
		return quickselectPoint(ls, index, lo, cur-1, depth+1)
	} else if index > cur {
		return quickselectPoint(ls, index, cur+1, hi, depth+1)
	} else {
		return ls[cur]
	}
}

func contains(set map[Point]bool, item Point) bool {
	_, exists := set[item]
	return exists
}

func bridge(pointsSet map[Point]bool, verticalLine float64) (Point, Point) {
	points := make([]Point, 0, len(pointsSet))
	for p := range pointsSet {
		points = append(points, p)
	}

	if len(points) == 2 {
		return points[0], points[1]
	}

	candidates := make(map[Point]bool)
	pairs := make([][2]Point, 0)
	modifyS := make([]Point, len(points))
	copy(modifyS, points)

	for len(modifyS) >= 2 {
		p1 := modifyS[0]
		modifyS = modifyS[1:]
		p2 := modifyS[0]
		modifyS = modifyS[1:]

		if p1.lessThan(p2) {
			pairs = append(pairs, [2]Point{p1, p2})
		} else {
			pairs = append(pairs, [2]Point{p2, p1})
		}
	}

	if len(modifyS) == 1 {
		candidates[modifyS[0]] = true
	}

	slopes := make([]float64, 0)
	validPairs := make([][2]Point, 0)

	for _, pair := range pairs {
		pi, pj := pair[0], pair[1]

		if pi.x == pj.x {
			if pi.y > pj.y {
				candidates[pi] = true
			} else {
				candidates[pj] = true
			}
		} else {
			slopes = append(slopes, (pi.y-pj.y)/(pi.x-pj.x))
			validPairs = append(validPairs, pair)
		}
	}

	if len(slopes) == 0 {
		// Handle case when no valid pairs with slopes are found
		if len(candidates) >= 2 {
			candidatesArray := make([]Point, 0, len(candidates))
			for p := range candidates {
				candidatesArray = append(candidatesArray, p)
			}
			return candidatesArray[0], candidatesArray[1]
		}
		// If we don't have enough candidates, return the first pair
		return points[0], points[1]
	}

	medianIndex := len(slopes)/2 - (1 - len(slopes)%2)
	slopesCopy := make([]float64, len(slopes))
	copy(slopesCopy, slopes)
	medianSlope := quickselectFloat(slopesCopy, medianIndex, 0, -1, 0)

	var small, equal, large [][2]Point

	for i, slope := range slopes {
		if slope < medianSlope {
			small = append(small, validPairs[i])
		} else if slope == medianSlope {
			equal = append(equal, validPairs[i])
		} else {
			large = append(large, validPairs[i])
		}
	}

	maxSlope := -math.Inf(1)
	for p := range pointsSet {
		maxSlope = math.Max(maxSlope, p.y-medianSlope*p.x)
	}

	maxSet := make([]Point, 0)
	for p := range pointsSet {
		if p.y-medianSlope*p.x == maxSlope {
			maxSet = append(maxSet, p)
		}
	}

	var left, right Point
	for i, p := range maxSet {
		if i == 0 || p.lessThan(left) {
			left = p
		}
		if i == 0 || !p.lessThan(right) {
			right = p
		}
	}

	if left.x <= verticalLine && right.x > verticalLine {
		return left, right
	}

	if right.x <= verticalLine {
		for _, pair := range large {
			candidates[pair[1]] = true
		}
		for _, pair := range equal {
			candidates[pair[1]] = true
		}
		for _, pair := range small {
			candidates[pair[0]] = true
			candidates[pair[1]] = true
		}
	}

	if left.x > verticalLine {
		for _, pair := range small {
			candidates[pair[0]] = true
		}
		for _, pair := range equal {
			candidates[pair[0]] = true
		}
		for _, pair := range large {
			candidates[pair[0]] = true
			candidates[pair[1]] = true
		}
	}

	return bridge(candidates, verticalLine)
}

func connect(lower, upper Point, pointsSet map[Point]bool) []Point {
	if lower.equals(upper) {
		return []Point{lower}
	}

	pointsVec := make([]Point, 0, len(pointsSet))
	for p := range pointsSet {
		pointsVec = append(pointsVec, p)
	}

	midIndex := len(pointsVec)/2 - 1
	pointsCopy := make([]Point, len(pointsVec))
	copy(pointsCopy, pointsVec)
	maxLeft := quickselectPoint(pointsCopy, midIndex, 0, -1, 0)
	
	pointsCopy = make([]Point, len(pointsVec))
	copy(pointsCopy, pointsVec)
	minRight := quickselectPoint(pointsCopy, midIndex+1, 0, -1, 0)

	left, right := bridge(pointsSet, (maxLeft.x+minRight.x)/2)

	pointsLeft := map[Point]bool{left: true}
	pointsRight := map[Point]bool{right: true}

	for p := range pointsSet {
		if p.x < left.x {
			pointsLeft[p] = true
		} else if p.x > right.x {
			pointsRight[p] = true
		}
	}

	leftResult := connect(lower, left, pointsLeft)
	rightResult := connect(right, upper, pointsRight)

	result := make([]Point, 0, len(leftResult)+len(rightResult))
	result = append(result, leftResult...)
	result = append(result, rightResult...)

	return result
}

func upperHull(pointsSet map[Point]bool) []Point {
	points := make([]Point, 0, len(pointsSet))
	for p := range pointsSet {
		points = append(points, p)
	}

	// Find the leftmost point
	var lower Point
	for i, p := range points {
		if i == 0 || p.x < lower.x || (p.x == lower.x && p.y < lower.y) {
			lower = p
		}
	}

	// Find the lowest point with the same x-coordinate as the minimum
	for _, point := range points {
		if point.x == lower.x && point.y > lower.y {
			lower = point
		}
	}

	// Find the rightmost point
	var upper Point
	for i, p := range points {
		if i == 0 || p.x > upper.x || (p.x == upper.x && p.y > upper.y) {
			upper = p
		}
	}

	filteredPoints := map[Point]bool{lower: true, upper: true}
	for _, p := range points {
		if lower.x < p.x && p.x < upper.x {
			filteredPoints[p] = true
		}
	}

	return connect(lower, upper, filteredPoints)
}

func convexHull(pointsSet map[Point]bool) []Point {
	upper := upperHull(pointsSet)

	flippedPoints := make(map[Point]bool)
	for p := range pointsSet {
		flippedPoints[newPoint(-p.x, -p.y)] = true
	}

	flippedUpper := upperHull(flippedPoints)
	lower := flipped(flippedUpper)

	// Check if we need to remove duplicates at the joining points
	if len(upper) > 0 && len(lower) > 0 && upper[len(upper)-1].equals(lower[0]) {
		upper = upper[:len(upper)-1]
	}

	if len(upper) > 0 && len(lower) > 0 && upper[0].equals(lower[len(lower)-1]) {
		lower = lower[:len(lower)-1]
	}

	result := make([]Point, 0, len(upper)+len(lower))
	result = append(result, upper...)
	result = append(result, lower...)

	return result
}

func main() {
	rand.Seed(time.Now().UnixNano())

	// Create points for a 2D projection of a 3D simplex
	points := map[Point]bool{
		newPoint(0.0, 0.0): true, // projection of [0.0, 0.0, 0.0]
		newPoint(1.0, 0.0): true, // projection of [1.0, 0.0, 0.0]
		newPoint(0.0, 1.0): true, // projection of [0.0, 1.0, 0.0]
		newPoint(0.5, 0.5): true, // projection of [0.0, 0.0, 1.0] (projected to 2D)
	}

	fmt.Println("Input points:")
	for p := range points {
		fmt.Printf("(%f, %f)\n", p.x, p.y)
	}

	hull := convexHull(points)

	fmt.Println("\nConvex hull points:")
	for _, p := range hull {
		fmt.Printf("(%f, %f)\n", p.x, p.y)
	}
}
