package main

import (
    "github.com/fogleman/gg"
    "math"
)

func greyBars(dc *gg.Context) {
    run := 0
    colorComp := 0.0 // component of the color
    for colCount := 8; colCount < 128; colCount *= 2 {
        // by this gap we change the background color
        colorGap := 255.0 / float64(colCount-1)
        colWidth := float64(dc.Width() / colCount)
        colHeight := float64(dc.Height() / 4)
        // switches color directions with each iteration of for loop
        if run%2 == 0 {
            colorComp = 0.0
        } else {
            colorComp = 255.0
            colorGap = -colorGap
        }
        xstart, ystart := 0.0, colHeight*float64(run)
        for i := 0; i < colCount; i++ {
            icolor := int(math.Round(colorComp)) // round to nearer integer
            dc.SetRGB255(icolor, icolor, icolor)
            dc.DrawRectangle(xstart, ystart, colWidth, colHeight)
            dc.Fill()
            xstart += colWidth
            colorComp += colorGap
        }
        run++
    }
}

func main() {
    dc := gg.NewContext(640, 320)
    greyBars(dc)
    dc.SavePNG("greybars.png")
}
