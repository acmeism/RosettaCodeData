package main

import (
    "github.com/fogleman/gg"
    "math"
)

const tau = 2 * math.Pi

func hsb2rgb(hue, sat, bri float64) (r, g, b int) {
    u := int(bri*255 + 0.5)
    if sat == 0 {
        r, g, b = u, u, u
    } else {
        h := (hue - math.Floor(hue)) * 6
        f := h - math.Floor(h)
        p := int(bri*(1-sat)*255 + 0.5)
        q := int(bri*(1-sat*f)*255 + 0.5)
        t := int(bri*(1-sat*(1-f))*255 + 0.5)
        switch int(h) {
        case 0:
            r, g, b = u, t, p
        case 1:
            r, g, b = q, u, p
        case 2:
            r, g, b = p, u, t
        case 3:
            r, g, b = p, q, u
        case 4:
            r, g, b = t, p, u
        case 5:
            r, g, b = u, p, q
        }
    }
    return
}

func colorWheel(dc *gg.Context) {
    width, height := dc.Width(), dc.Height()
    centerX, centerY := width/2, height/2
    radius := centerX
    if centerY < radius {
        radius = centerY
    }
    for y := 0; y < height; y++ {
        dy := float64(y - centerY)
        for x := 0; x < width; x++ {
            dx := float64(x - centerX)
            dist := math.Sqrt(dx*dx + dy*dy)
            if dist <= float64(radius) {
                theta := math.Atan2(dy, dx)
                hue := (theta + math.Pi) / tau
                r, g, b := hsb2rgb(hue, 1, 1)
                dc.SetRGB255(r, g, b)
                dc.SetPixel(x, y)
            }
        }
    }
}

func main() {
    const width, height = 480, 480
    dc := gg.NewContext(width, height)
    dc.SetRGB(1, 1, 1) // set background color to white
    dc.Clear()
    colorWheel(dc)
    dc.SavePNG("color_wheel.png")
}
