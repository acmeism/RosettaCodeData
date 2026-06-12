package main

import "github.com/fogleman/gg"

var p = [3]gg.Point{{10, 10}, {100, 200}, {200, 10}}

func lagrange(x float64) float64 {
    return (x-p[1].X)*(x-p[2].X)/(p[0].X-p[1].X)/(p[0].X-p[2].X)*p[0].Y +
        (x-p[0].X)*(x-p[2].X)/(p[1].X-p[0].X)/(p[1].X-p[2].X)*p[1].Y +
        (x-p[0].X)*(x-p[1].X)/(p[2].X-p[0].X)/(p[2].X-p[1].X)*p[2].Y
}

func getPoints(n int) []gg.Point {
    pts := make([]gg.Point, 2*n+1)
    dx := (p[1].X - p[0].X) / float64(n)
    for i := 0; i < n; i++ {
        x := p[0].X + dx*float64(i)
        pts[i] = gg.Point{x, lagrange(x)}
    }
    dx = (p[2].X - p[1].X) / float64(n)
    for i := n; i < 2*n+1; i++ {
        x := p[1].X + dx*float64(i-n)
        pts[i] = gg.Point{x, lagrange(x)}
    }
    return pts
}

func main() {
    const n = 50 // more than enough for this
    dc := gg.NewContext(210, 210)
    dc.SetRGB(1, 1, 1) // White background
    dc.Clear()
    for _, pt := range getPoints(n) {
        dc.LineTo(pt.X, pt.Y)
    }
    dc.SetRGB(0, 0, 0) // Black curve
    dc.SetLineWidth(1)
    dc.Stroke()
    dc.SavePNG("quadratic_curve.png")
}
