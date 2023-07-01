package main

import "github.com/fogleman/gg"

var palette = [2]string{
    "FFFFFF", // white
    "000000", // black
}

func pinstripe(dc *gg.Context) {
    w := dc.Width()
    h := dc.Height() / 4
    for b := 1; b <= 4; b++ {
        for x, ci := 0, 0; x < w; x, ci = x+b, ci+1 {
            dc.SetHexColor(palette[ci%2])
            y := h * (b - 1)
            dc.DrawRectangle(float64(x), float64(y), float64(b), float64(h))
            dc.Fill()
        }
    }
}

func main() {
    dc := gg.NewContext(900, 600)
    pinstripe(dc)
    dc.SavePNG("w_pinstripe.png")
}
