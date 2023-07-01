package main

import (
    "github.com/fogleman/gg"
    "math"
)

func Pentagram(x, y, r float64) []gg.Point {
    points := make([]gg.Point, 5)
    for i := 0; i < 5; i++ {
        fi := float64(i)
        angle := 2*math.Pi*fi/5 - math.Pi/2
        points[i] = gg.Point{x + r*math.Cos(angle), y + r*math.Sin(angle)}
    }
    return points
}

func main() {
    points := Pentagram(320, 320, 250)
    dc := gg.NewContext(640, 640)
    dc.SetRGB(1, 1, 1) // White
    dc.Clear()
    for i := 0; i <= 5; i++ {
        index := (i * 2) % 5
        p := points[index]
        dc.LineTo(p.X, p.Y)
    }
    dc.SetHexColor("#6495ED") // Cornflower Blue
    dc.SetFillRule(gg.FillRuleWinding)
    dc.FillPreserve()
    dc.SetRGB(0, 0, 0) // Black
    dc.SetLineWidth(5)
    dc.Stroke()
    dc.SavePNG("pentagram.png")
}
