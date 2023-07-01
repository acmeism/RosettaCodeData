package main

import (
    "fmt"
    "image"
    "image/color"
    "image/draw"
    "image/png"
    "math"
    "os"
)

// separation of the the two endpoints
// make this a power of 2 for prettiest output
const sep = 512
// depth of recursion.  adjust as desired for different visual effects.
const depth = 14

var s = math.Sqrt2 / 2
var sin = []float64{0, s, 1, s, 0, -s, -1, -s}
var cos = []float64{1, s, 0, -s, -1, -s, 0, s}
var p = color.NRGBA{64, 192, 96, 255}
var b *image.NRGBA

func main() {
    width := sep * 11 / 6
    height := sep * 4 / 3
    bounds := image.Rect(0, 0, width, height)
    b = image.NewNRGBA(bounds)
    draw.Draw(b, bounds, image.NewUniform(color.White), image.ZP, draw.Src)
    dragon(14, 0, 1, sep, sep/2, sep*5/6)
    f, err := os.Create("dragon.png")
    if err != nil {
        fmt.Println(err)
        return
    }
    if err = png.Encode(f, b); err != nil {
        fmt.Println(err)
    }
    if err = f.Close(); err != nil {
        fmt.Println(err)
    }
}

func dragon(n, a, t int, d, x, y float64) {
    if n <= 1 {
        // Go packages used here do not have line drawing functions
        // so we implement a very simple line drawing algorithm here.
        // We take advantage of knowledge that we are always drawing
        // 45 degree diagonal lines.
        x1 := int(x + .5)
        y1 := int(y + .5)
        x2 := int(x + d*cos[a] + .5)
        y2 := int(y + d*sin[a] + .5)
        xInc := 1
        if x1 > x2 {
            xInc = -1
        }
        yInc := 1
        if y1 > y2 {
            yInc = -1
        }
        for x, y := x1, y1; ; x, y = x+xInc, y+yInc {
            b.Set(x, y, p)
            if x == x2 {
                break
            }
        }
        return
    }
    d *= s
    a1 := (a - t) & 7
    a2 := (a + t) & 7
    dragon(n-1, a1, 1, d, x, y)
    dragon(n-1, a2, -1, d, x+d*cos[a1], y+d*sin[a1])
}
