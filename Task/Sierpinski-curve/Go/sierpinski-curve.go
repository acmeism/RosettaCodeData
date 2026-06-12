package main

import (
    "github.com/fogleman/gg"
    "math"
)

var (
    width  = 770.0
    height = 770.0
    dc     = gg.NewContext(int(width), int(height))
)

var cx, cy, h float64

func lineTo(newX, newY float64) {
    dc.LineTo(newX-width/2+h, height-newY+2*h)
    cx, cy = newX, newY
}

func lineN() { lineTo(cx, cy-2*h) }
func lineS() { lineTo(cx, cy+2*h) }
func lineE() { lineTo(cx+2*h, cy) }
func lineW() { lineTo(cx-2*h, cy) }

func lineNW() { lineTo(cx-h, cy-h) }
func lineNE() { lineTo(cx+h, cy-h) }
func lineSE() { lineTo(cx+h, cy+h) }
func lineSW() { lineTo(cx-h, cy+h) }

func sierN(level int) {
    if level == 1 {
        lineNE()
        lineN()
        lineNW()
    } else {
        sierN(level - 1)
        lineNE()
        sierE(level - 1)
        lineN()
        sierW(level - 1)
        lineNW()
        sierN(level - 1)
    }
}

func sierE(level int) {
    if level == 1 {
        lineSE()
        lineE()
        lineNE()
    } else {
        sierE(level - 1)
        lineSE()
        sierS(level - 1)
        lineE()
        sierN(level - 1)
        lineNE()
        sierE(level - 1)
    }
}

func sierS(level int) {
    if level == 1 {
        lineSW()
        lineS()
        lineSE()
    } else {
        sierS(level - 1)
        lineSW()
        sierW(level - 1)
        lineS()
        sierE(level - 1)
        lineSE()
        sierS(level - 1)
    }
}

func sierW(level int) {
    if level == 1 {
        lineNW()
        lineW()
        lineSW()
    } else {
        sierW(level - 1)
        lineNW()
        sierN(level - 1)
        lineW()
        sierS(level - 1)
        lineSW()
        sierW(level - 1)
    }
}

func squareCurve(level int) {
    sierN(level)
    lineNE()
    sierE(level)
    lineSE()
    sierS(level)
    lineSW()
    sierW(level)
    lineNW()
    lineNE() // needed to close the square in the top left hand corner
}

func main() {
    dc.SetRGB(0, 0, 1) // blue background
    dc.Clear()
    level := 5
    cx, cy = width/2, height
    h = cx / math.Pow(2, float64(level+1))
    squareCurve(level)
    dc.SetRGB255(255, 255, 0) // yellow curve
    dc.SetLineWidth(2)
    dc.Stroke()
    dc.SavePNG("sierpinski_curve.png")
}
