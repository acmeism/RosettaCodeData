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
    b.FillRgb(0xdfefff)
    blue := raster.Rgb(0x8fcfff)
    b.LineRgb(7, 12, 307, 122, blue)
    b.LineRgb(177, 12, 127, 222, blue)
    err := b.WritePpmFile("bresenham.ppm")
    if err != nil {
        fmt.Println(err)
    }
}
