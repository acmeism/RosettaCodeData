package main

import (
    "fmt"
    "raster"
)

func main() {
    b := raster.NewBitmap(400, 300)
    b.FillRgb(0xdfffef)
    b.Bézier2Rgb(20, 150, 500, -100, 300, 280, raster.Rgb(0x3f8fef))
    if err := b.WritePpmFile("bez2.ppm"); err != nil {
        fmt.Println(err)
    }
}
