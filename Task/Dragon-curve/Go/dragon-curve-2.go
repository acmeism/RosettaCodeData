package main

// Files required to build supporting package raster are found in:
// * Bitmap
// * Write a PPM file

import (
    "math"
    "raster"
)

// separation of the the two endpoints
// make this a power of 2 for prettiest output
const sep = 512
// depth of recursion.  adjust as desired for different visual effects.
const depth = 14

var s = math.Sqrt2 / 2
var sin = []float64{0, s, 1, s, 0, -s, -1, -s}
var cos = []float64{1, s, 0, -s, -1, -s, 0, s}
var p = raster.Pixel{64, 192, 96}
var b *raster.Bitmap

func main() {
    width := sep * 11 / 6
    height := sep * 4 / 3
    b = raster.NewBitmap(width, height)
    b.Fill(raster.Pixel{255, 255, 255})
    dragon(14, 0, 1, sep, sep/2, sep*5/6)
    b.WritePpmFile("dragon.ppm")
}

func dragon(n, a, t int, d, x, y float64) {
    if n <= 1 {
        b.Line(int(x+.5), int(y+.5), int(x+d*cos[a]+.5), int(y+d*sin[a]+.5), p)
        return
    }
    d *= s
    a1 := (a - t) & 7
    a2 := (a + t) & 7
    dragon(n-1, a1, 1, d, x, y)
    dragon(n-1, a2, -1, d, x+d*cos[a1], y+d*sin[a1])
}
