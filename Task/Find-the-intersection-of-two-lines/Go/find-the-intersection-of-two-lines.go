package main

import (
	"fmt"
	"errors"
)

type Point struct {
	x float64
	y float64
}

type Line struct {
	slope float64
	yint float64
}

func CreateLine (a, b Point) Line {
	slope := (b.y-a.y) / (b.x-a.x)
	yint := a.y - slope*a.x
	return Line{slope, yint}
}

func EvalX (l Line, x float64) float64 {
	return l.slope*x + l.yint
}

func Intersection (l1, l2 Line) (Point, error) {
	if l1.slope == l2.slope {
		return Point{}, errors.New("The lines do not intersect")
	}
	x := (l2.yint-l1.yint) / (l1.slope-l2.slope)
	y := EvalX(l1, x)
	return Point{x, y}, nil
}

func main() {
	l1 := CreateLine(Point{4, 0}, Point{6, 10})
	l2 := CreateLine(Point{0, 3}, Point{10, 7})
	if result, err := Intersection(l1, l2); err == nil {
		fmt.Println(result)
	} else {
		fmt.Println("The lines do not intersect")
	}
}
