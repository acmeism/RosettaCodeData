package main

import (
    "github.com/fogleman/gg"
    "image/color"
    "math"
)

var (
    red     = color.RGBA{255, 0, 0, 255}
    green   = color.RGBA{0, 255, 0, 255}
    blue    = color.RGBA{0, 0, 255, 255}
    magenta = color.RGBA{255, 0, 255, 255}
    cyan    = color.RGBA{0, 255, 255, 255}
)

var (
    w, h        = 640, 640
    dc          = gg.NewContext(w, h)
    deg72       = gg.Radians(72)
    scaleFactor = 1 / (2 + math.Cos(deg72)*2)
    palette     = [5]color.Color{red, green, blue, magenta, cyan}
    colorIndex  = 0
)

func drawPentagon(x, y, side float64, depth int) {
    angle := 3 * deg72
    if depth == 0 {
        dc.MoveTo(x, y)
        for i := 0; i < 5; i++ {
            x += math.Cos(angle) * side
            y -= math.Sin(angle) * side
            dc.LineTo(x, y)
            angle += deg72
        }
        dc.SetColor(palette[colorIndex])
        dc.Fill()
        colorIndex = (colorIndex + 1) % 5
    } else {
        side *= scaleFactor
        dist := side * (1 + math.Cos(deg72)*2)
        for i := 0; i < 5; i++ {
            x += math.Cos(angle) * dist
            y -= math.Sin(angle) * dist
            drawPentagon(x, y, side, depth-1)
            angle += deg72
        }
    }
}

func main() {
    dc.SetRGB(1, 1, 1) // White background
    dc.Clear()
    order := 5 // Can also set this to 1, 2, 3 or 4
    hw := float64(w / 2)
    margin := 20.0
    radius := hw - 2*margin
    side := radius * math.Sin(math.Pi/5) * 2
    drawPentagon(hw, 3*margin, side, order-1)
    dc.SavePNG("sierpinski_pentagon.png")
}
