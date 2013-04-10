package main

import (
    "fmt"
    "raster"
)

func main() {
    b := raster.NewBitmap(400, 300)
    b.FillRgb(0xffefbf)
    b.Bézier3Rgb(20, 200, 700, 50, -300, 50, 380, 150, raster.Rgb(0x3f8fef))
    if err := b.WritePpmFile("bez3.ppm"); err != nil {
        fmt.Println(err)
    }
}
