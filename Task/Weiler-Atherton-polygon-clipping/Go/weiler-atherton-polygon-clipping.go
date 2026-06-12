package main

import (
	"fmt"
	"math"
	"sort"
)

// Point represents a 2D point
type Point struct {
	X, Y int
}

// Line represents a line segment between two points
type Line struct {
	Start, End Point
}

// Polygon represents a polygon as a collection of points
type Polygon struct {
	Points []Point
}

// InterVertexType represents the type of intersection vertex
type InterVertexType int

const (
	InsideVertex InterVertexType = iota
	OutsideVertex
	InIntersection
	OutIntersection
)

// InterVertex represents an intersection vertex
type InterVertex struct {
	Type  InterVertexType
	Point Point
}

// GetPoint returns the point of the InterVertex
func (iv InterVertex) GetPoint() Point {
	return iv.Point
}

// GetFirstInIntersection finds and removes the first InIntersection from the list
func GetFirstInIntersection(list *[]InterVertex) *Point {
	for i, vertex := range *list {
		if vertex.Type == InIntersection {
			point := vertex.GetPoint()
			*list = (*list)[i:]
			return &point
		}
	}
	return nil
}

// PolyListOptionType represents the type of polygon list option
type PolyListOptionType int

const (
	List PolyListOptionType = iota
	InsidePoly
	None
)

// PolyListOption represents options for polygon lists
type PolyListOption struct {
	Type            PolyListOptionType
	InterVertexList []InterVertex
	Points          []Point
}

// IsInPolygon checks if a point is inside a polygon using ray casting
func IsInPolygon(point Point, poly Polygon) bool {
	x, y := point.X, point.Y
	inside := false
	j := len(poly.Points) - 1

	for i := 0; i < len(poly.Points); i++ {
		xi, yi := poly.Points[i].X, poly.Points[i].Y
		xj, yj := poly.Points[j].X, poly.Points[j].Y

		intersect := ((yi > y) != (yj > y)) &&
			(float64(x) < (float64(xj-xi)*float64(y-yi))/float64(yj-yi)+float64(xi))

		if intersect {
			inside = !inside
		}
		j = i
	}

	return inside
}

// DistanceCmp compares Manhattan distances from a reference point
func DistanceCmp(self, first, second Point) int {
	dstFirst := abs(self.X-first.X) + abs(self.Y-first.Y)
	dstSecond := abs(self.X-second.X) + abs(self.Y-second.Y)

	if dstFirst < dstSecond {
		return -1
	} else if dstFirst > dstSecond {
		return 1
	}
	return 0
}

// abs returns the absolute value of an integer
func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

// IsInLine checks if a point lies on a line segment
func IsInLine(point Point, line Line) bool {
	dxc := point.X - line.Start.X
	dyc := point.Y - line.Start.Y

	dxl := line.End.X - line.Start.X
	dyl := line.End.Y - line.Start.Y

	cross := dxc*dyl - dyc*dxl

	if cross != 0 {
		return false
	}

	if abs(dxl) >= abs(dyl) {
		if dxl > 0 {
			return line.Start.X <= point.X && point.X <= line.End.X
		} else {
			return line.End.X <= point.X && point.X <= line.Start.X
		}
	} else {
		if dyl > 0 {
			return line.Start.Y <= point.Y && point.Y <= line.End.Y
		} else {
			return line.End.Y <= point.Y && point.Y <= line.Start.Y
		}
	}
}

// GetIntersection finds the intersection point of two line segments
func GetIntersection(self, line Line) *Point {
	line1Start := self.Start
	line1End := self.End
	line2Start := line.Start
	line2End := line.End

	den := (line2End.Y-line2Start.Y)*(line1End.X-line1Start.X) -
		(line2End.X-line2Start.X)*(line1End.Y-line1Start.Y)

	if den == 0 {
		return nil
	}

	a := line1Start.Y - line2Start.Y
	b := line1Start.X - line2Start.X

	num1 := (line2End.X-line2Start.X)*a - (line2End.Y-line2Start.Y)*b
	num2 := (line1End.X-line1Start.X)*a - (line1End.Y-line1Start.Y)*b

	aF := float64(num1) / float64(den)
	bF := float64(num2) / float64(den)

	if aF < 0.0 || aF > 1.0 || bF < 0.0 || bF > 1.0 {
		return nil
	}

	result := Point{
		X: line1Start.X + int(math.Round(aF*float64(line1End.X-line1Start.X))),
		Y: line1Start.Y + int(math.Round(aF*float64(line1End.Y-line1Start.Y))),
	}

	return &result
}

// IsClockwise determines if polygon vertices are ordered clockwise
func IsClockwise(poly Polygon) bool {
	sum := 0
	for i := 0; i < len(poly.Points); i++ {
		j := i + 1
		if j == len(poly.Points) {
			j = 0
		}
		sum += (poly.Points[j].X - poly.Points[i].X) * (poly.Points[j].Y + poly.Points[i].Y)
	}
	return sum < 0
}

// GetReversed returns a polygon with reversed point order
func GetReversed(poly Polygon) Polygon {
	points := make([]Point, len(poly.Points))
	copy(points, poly.Points)
	
	// Reverse the slice
	for i, j := 0, len(points)-1; i < j; i, j = i+1, j-1 {
		points[i], points[j] = points[j], points[i]
	}
	
	return Polygon{Points: points}
}

// GetFirstOutsideVertexIndex finds the first vertex outside the clipping polygon
func GetFirstOutsideVertexIndex(subject, poly Polygon) *int {
	for i, point := range subject.Points {
		if !IsInPolygon(point, poly) {
			return &i
		}
	}
	return nil
}

// GetFirstInsideVertexIndex finds the first vertex inside the clipping polygon
func GetFirstInsideVertexIndex(subject, poly Polygon) *int {
	for i, point := range subject.Points {
		if IsInPolygon(point, poly) {
			return &i
		}
	}
	return nil
}

// GetIntersectionsWithLine finds all intersections between a polygon and a line
func GetIntersectionsWithLine(poly Polygon, line Line, cursorInside *bool) []InterVertex {
	var intersections []Point

	for i := 0; i < len(poly.Points); i++ {
		start := poly.Points[i]
		nextI := (i + 1) % len(poly.Points)
		end := poly.Points[nextI]

		l := Line{Start: start, End: end}
		intersection := GetIntersection(l, line)

		if intersection != nil &&
			*intersection != line.Start && *intersection != line.End &&
			*intersection != start && *intersection != end {
			intersections = append(intersections, *intersection)
		}
	}

	// Sort intersections by distance from line start
	sort.Slice(intersections, func(i, j int) bool {
		return DistanceCmp(line.Start, intersections[i], intersections[j]) < 0
	})

	var result []InterVertex
	for _, x := range intersections {
		if *cursorInside {
			*cursorInside = !*cursorInside
			result = append(result, InterVertex{Type: OutIntersection, Point: x})
		} else {
			*cursorInside = !*cursorInside
			result = append(result, InterVertex{Type: InIntersection, Point: x})
		}
	}

	return result
}

// GetInterVertexList creates a list of intersection vertices
func GetInterVertexList(subject, poly Polygon) PolyListOption {
	subjectCopy := subject
	if !IsClockwise(subjectCopy) {
		subjectCopy = GetReversed(subjectCopy)
	}

	cursorInside := false

	startIndexPtr := GetFirstOutsideVertexIndex(subjectCopy, poly)
	if startIndexPtr != nil {
		startIndex := *startIndexPtr

		if GetFirstInsideVertexIndex(subjectCopy, poly) == nil {
			allInside := true
			for _, point := range poly.Points {
				if !IsInPolygon(point, subjectCopy) {
					allInside = false
					break
				}
			}

			if allInside {
				return PolyListOption{Type: InsidePoly, Points: poly.Points}
			}
		}

		var result []InterVertex

		for iOffset := 0; iOffset < len(subjectCopy.Points); iOffset++ {
			i := (startIndex + iOffset) % len(subjectCopy.Points)
			start := subjectCopy.Points[i]

			// Check vertex
			if i != startIndex && IsInPolygon(start, poly) {
				result = append(result, InterVertex{Type: InsideVertex, Point: start})
			} else {
				result = append(result, InterVertex{Type: OutsideVertex, Point: start})
			}

			// Check intersection
			nextI := (i + 1) % len(subjectCopy.Points)
			end := subjectCopy.Points[nextI]
			line := Line{Start: start, End: end}

			intersections := GetIntersectionsWithLine(poly, line, &cursorInside)
			result = append(result, intersections...)
		}

		// Check if there are any intersections
		hasIntersections := false
		for _, vertex := range result {
			if vertex.Type == InIntersection || vertex.Type == OutIntersection {
				hasIntersections = true
				break
			}
		}

		if !hasIntersections {
			return PolyListOption{Type: None}
		} else {
			return PolyListOption{Type: List, InterVertexList: result}
		}
	} else {
		return PolyListOption{Type: InsidePoly, Points: subject.Points}
	}
}

// CollectFromListResult represents the result of collecting from a list
type CollectFromListResult struct {
	Points    []Point
	LastPoint Point
}

// CollectFromList collects points from an intersection vertex list
func CollectFromList(list *[]InterVertex, startPoint Point) *CollectFromListResult {
	initialVertexNotFound := true
	var lastPoint *Point
	startI, endI := 0, 0
	dontSkip := len(*list) > 0 && (*list)[0].GetPoint() == startPoint

	var points []Point
	i := 0

	// Skip until InIntersection occurs, but include the InIntersection
	for i < len(*list) && initialVertexNotFound && !dontSkip {
		next := (i + 1) % len(*list)
		nextPoint := (*list)[next]

		if nextPoint.Type == InIntersection || nextPoint.Type == OutIntersection {
			if nextPoint.GetPoint() == startPoint {
				startI = next
				initialVertexNotFound = false
				break
			}
		}
		i++
	}

	// Collect points
	if !initialVertexNotFound || dontSkip {
		i = startI
		continueCollecting := true

		for continueCollecting && i < len(*list) {
			vertex := (*list)[i]

			if vertex.Type == OutIntersection {
				endI = i
				point := vertex.GetPoint()
				lastPoint = &point
				continueCollecting = false
			} else {
				points = append(points, vertex.GetPoint())
			}

			i++
		}
	}

	amount := endI - startI + 1
	if endI >= startI && startI+amount <= len(*list) {
		*list = append((*list)[:startI], (*list)[startI+amount:]...)
	}

	if len(points) > 0 && lastPoint != nil {
		return &CollectFromListResult{Points: points, LastPoint: *lastPoint}
	}
	return nil
}

// GetClipPolygon generates a clipped polygon from intersection lists
func GetClipPolygon(subject, clip *[]InterVertex, initial Point) []Point {
	var result []Point
	subjectAsList := true
	startPoint := initial
	endPoint := (*subject)[len(*subject)-1].GetPoint()

	for initial != endPoint {
		var values *CollectFromListResult
		if subjectAsList {
			values = CollectFromList(subject, startPoint)
		} else {
			values = CollectFromList(clip, startPoint)
		}

		if values != nil {
			endPoint = values.LastPoint
			startPoint = endPoint
			subjectAsList = !subjectAsList

			result = append(result, values.Points...)
		} else {
			fmt.Println("something went wrong")
			fmt.Printf("res size: %d\n", len(result))
			return nil
		}
	}

	if len(result) > 0 {
		// Filter consecutive duplicate points
		filtered := []Point{result[0]}
		for i := 1; i < len(result); i++ {
			if result[i] != result[i-1] {
				filtered = append(filtered, result[i])
			}
		}
		return filtered
	}
	return nil
}

// GetClipPolygons generates multiple clipped polygons
func GetClipPolygons(subject, clip *[]InterVertex) [][]Point {
	var result [][]Point

	for {
		startPoint := GetFirstInIntersection(subject)
		if startPoint == nil {
			break
		}

		poly := GetClipPolygon(subject, clip, *startPoint)
		if poly != nil {
			result = append(result, poly)
		} else {
			break
		}
	}

	return result
}

// Clip performs polygon clipping between two polygons
func Clip(self, other Polygon) [][]Point {
	option := GetInterVertexList(self, other)
	otherOption := GetInterVertexList(other, self)

	if option.Type == List {
		subjectList := option.InterVertexList

		if otherOption.Type == List {
			clipList := otherOption.InterVertexList
			return GetClipPolygons(&subjectList, &clipList)
		} else if otherOption.Type == InsidePoly {
			return [][]Point{otherOption.Points}
		} else { // None
			return nil
		}
	} else if option.Type == InsidePoly {
		return [][]Point{option.Points}
	} else { // None
		return nil
	}
}

// RunTests runs test cases
func RunTests() {
	// Test IsInLine
	{
		p := Point{5, 10}
		line := Line{Point{5, 5}, Point{5, 20}}
		result := IsInLine(p, line)
		fmt.Printf("IsInLine test 1: %s\n", map[bool]string{true: "PASS", false: "FAIL"}[result])

		pF := Point{3, 4}
		lineF := Line{Point{5, 5}, Point{5, 20}}
		resultF := IsInLine(pF, lineF)
		fmt.Printf("IsInLine test 2: %s\n", map[bool]string{true: "PASS", false: "FAIL"}[!resultF])
	}

	// Test Clip
	{
		poly := Polygon{
			Points: []Point{
				{180, 420}, {180, 120}, {520, 120}, {520, 420}, {420, 420}, {320, 220},
			},
		}

		interPolygon := Polygon{
			Points: []Point{
				{60, 220}, {330, 120}, {410, 290}, {80, 480}, {280, 280},
			},
		}

		polygons := Clip(poly, interPolygon)
		if polygons != nil && len(polygons) > 0 {
			fmt.Printf("Clip test: PASS - Found %d polygons\n", len(polygons))

			// Print first polygon points
			if len(polygons[0]) > 0 {
				fmt.Println("First polygon points:")
				for _, p := range polygons[0] {
					fmt.Printf("  Point: (%d, %d)\n", p.X, p.Y)
				}
			}
		} else {
			fmt.Println("Clip test: FAIL - No polygons found")
		}
	}
}

func main() {
	RunTests()
}
