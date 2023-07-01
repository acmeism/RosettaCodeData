package main

import (
    "github.com/fogleman/gg"
    "math"
)

var dc = gg.NewContext(512, 512)

func koch(x1, y1, x2, y2 float64, iter int) {
    angle := math.Pi / 3 // 60 degrees
    x3 := (x1*2 + x2) / 3
    y3 := (y1*2 + y2) / 3
    x4 := (x1 + x2*2) / 3
    y4 := (y1 + y2*2) / 3
    x5 := x3 + (x4-x3)*math.Cos(angle) + (y4-y3)*math.Sin(angle)
    y5 := y3 - (x4-x3)*math.Sin(angle) + (y4-y3)*math.Cos(angle)
    if iter > 0 {
        iter--
        koch(x1, y1, x3, y3, iter)
        koch(x3, y3, x5, y5, iter)
        koch(x5, y5, x4, y4, iter)
        koch(x4, y4, x2, y2, iter)
    } else {
        dc.LineTo(x1, y1)
        dc.LineTo(x3, y3)
        dc.LineTo(x5, y5)
        dc.LineTo(x4, y4)
        dc.LineTo(x2, y2)
    }
}

func main() {
    dc.SetRGB(1, 1, 1) // White background
    dc.Clear()
    koch(100, 100, 400, 400, 4)
    dc.SetRGB(0, 0, 1) // Blue curve
    dc.SetLineWidth(2)
    dc.Stroke()
    dc.SavePNG("koch.png")
}
