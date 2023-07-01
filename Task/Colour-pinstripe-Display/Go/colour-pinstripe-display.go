package main

import "github.com/fogleman/gg"

var palette = [8]string{
    "000000", // black
    "FF0000", // red
    "00FF00", // green
    "0000FF", // blue
    "FF00FF", // magenta
    "00FFFF", // cyan
    "FFFF00", // yellow
    "FFFFFF", // white
}

func pinstripe(dc *gg.Context) {
    w := dc.Width()
    h := dc.Height() / 4
    for b := 1; b <= 4; b++ {
        for x, ci := 0, 0; x < w; x, ci = x+b, ci+1 {
            dc.SetHexColor(palette[ci%8])
            y := h * (b - 1)
            dc.DrawRectangle(float64(x), float64(y), float64(b), float64(h))
            dc.Fill()
        }
    }
}

func main() {
    dc := gg.NewContext(900, 600)
    pinstripe(dc)
    dc.SavePNG("color_pinstripe.png")
}
