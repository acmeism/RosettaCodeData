package main

import (
	"fmt"
	"image"
	"sort"
)


// ConvexHull returns the set of points that define the
// convex hull of p in CCW order starting from the left most.
func (p points) ConvexHull() points {
	// From https://en.wikibooks.org/wiki/Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain
	// with only minor deviations.
	sort.Sort(p)
	var h points

	// Lower hull
	for _, pt := range p {
		for len(h) >= 2 && !ccw(h[len(h)-2], h[len(h)-1], pt) {
			h = h[:len(h)-1]
		}
		h = append(h, pt)
	}

	// Upper hull
	for i, t := len(p)-2, len(h)+1; i >= 0; i-- {
		pt := p[i]
		for len(h) >= t && !ccw(h[len(h)-2], h[len(h)-1], pt) {
			h = h[:len(h)-1]
		}
		h = append(h, pt)
	}

	return h[:len(h)-1]
}

// ccw returns true if the three points make a counter-clockwise turn
func ccw(a, b, c image.Point) bool {
	return ((b.X - a.X) * (c.Y - a.Y)) > ((b.Y - a.Y) * (c.X - a.X))
}

type points []image.Point

func (p points) Len() int      { return len(p) }
func (p points) Swap(i, j int) { p[i], p[j] = p[j], p[i] }
func (p points) Less(i, j int) bool {
	if p[i].X == p[j].X {
		return p[i].Y < p[i].Y
	}
	return p[i].X < p[j].X
}

func main() {
	pts := points{
		{16, 3}, {12, 17}, {0, 6}, {-4, -6}, {16, 6},
		{16, -7}, {16, -3}, {17, -4}, {5, 19}, {19, -8},
		{3, 16}, {12, 13}, {3, -4}, {17, 5}, {-3, 15},
		{-3, -9}, {0, 11}, {-9, -3}, {-4, -2}, {12, 10},
	}
	hull := pts.ConvexHull()
	fmt.Println("Convex Hull:", hull)
}
