package main

// Files required to build supporting package raster are found in:
// * This task (immediately above)
// * Bitmap
// * Write a PPM file

import (
    "raster"
    "fmt"
)

func main() {
    b := raster.NewBitmap(400, 300)
    b.FillRgb(0xffdf20) // yellow
    // large circle, demonstrating clipping to image boundaries
    b.CircleRgb(300, 249, 200, 0xff2020) // red
    if err := b.WritePpmFile("circle.ppm"); err != nil {
        fmt.Println(err)
    }
}
