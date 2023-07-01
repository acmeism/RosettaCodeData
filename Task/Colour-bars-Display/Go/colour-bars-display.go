package main

import "github.com/fogleman/gg"

var colors = [8]string{
    "000000", // black
    "FF0000", // red
    "00FF00", // green
    "0000FF", // blue
    "FF00FF", // magenta
    "00FFFF", // cyan
    "FFFF00", // yellow
    "FFFFFF", // white
}

func drawBars(dc *gg.Context) {
    w := float64(dc.Width() / len(colors))
    h := float64(dc.Height())
    for i := range colors {
        dc.SetHexColor(colors[i])
        dc.DrawRectangle(w*float64(i), 0, w, h)
        dc.Fill()
    }
}

func main() {
    dc := gg.NewContext(400, 400)
    drawBars(dc)
    dc.SavePNG("color_bars.png")
}
