package main

import (
    "github.com/fogleman/gg"
    "math"
)

var (
    width  = 770.0
    height = 770.0
    dc     = gg.NewContext(int(width), int(height))
    iy     = 1.0
    theta  = 0
)

var cx, cy, h float64

func arrowhead(order int, length float64) {
    // if order is even, we can just draw the curve
    if order&1 == 0 {
        curve(order, length, 60)
    } else {
        turn(60)
        curve(order, length, -60)
    }
    drawLine(length) // needed to make base symmetric
}

func drawLine(length float64) {
    dc.LineTo(cx-width/2+h, (height-cy)*iy+2*h)
    rads := gg.Radians(float64(theta))
    cx += length * math.Cos(rads)
    cy += length * math.Sin(rads)
}

func turn(angle int) {
    theta = (theta + angle) % 360
}

func curve(order int, length float64, angle int) {
    if order == 0 {
        drawLine(length)
    } else {
        curve(order-1, length/2, -angle)
        turn(angle)
        curve(order-1, length/2, angle)
        turn(angle)
        curve(order-1, length/2, -angle)
    }
}

func main() {
    dc.SetRGB(0, 0, 0) // black background
    dc.Clear()
    order := 6
    if order&1 == 0 {
        iy = -1 // apex will point upwards
    }
    cx, cy = width/2, height
    h = cx / 2
    arrowhead(order, cx)
    dc.SetRGB255(255, 0, 255) // magenta curve
    dc.SetLineWidth(2)
    dc.Stroke()
    dc.SavePNG("sierpinski_arrowhead_curve.png")
}
