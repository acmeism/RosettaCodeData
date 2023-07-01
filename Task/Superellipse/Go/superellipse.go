package main

import (
    "github.com/fogleman/gg"
    "math"
)

/* assumes a and b are always equal */
func superEllipse(dc *gg.Context, n float64, a int) {
    hw := float64(dc.Width() / 2)
    hh := float64(dc.Height() / 2)

    // calculate y for each x
    y := make([]float64, a+1)
    for x := 0; x <= a; x++ {
        aa := math.Pow(float64(a), n)
        xx := math.Pow(float64(x), n)
        y[x] = math.Pow(aa-xx, 1.0/n)
    }

    // draw quadrants
    for x := a; x >= 0; x-- {
        dc.LineTo(hw+float64(x), hh-y[x])
    }
    for x := 0; x <= a; x++ {
        dc.LineTo(hw+float64(x), hh+y[x])
    }
    for x := a; x >= 0; x-- {
        dc.LineTo(hw-float64(x), hh+y[x])
    }
    for x := 0; x <= a; x++ {
        dc.LineTo(hw-float64(x), hh-y[x])
    }

    dc.SetRGB(1, 1, 1) // white ellipse
    dc.Fill()
}

func main() {
    dc := gg.NewContext(500, 500)
    dc.SetRGB(0, 0, 0) // black background
    dc.Clear()
    superEllipse(dc, 2.5, 200)
    dc.SavePNG("superellipse.png")
}
