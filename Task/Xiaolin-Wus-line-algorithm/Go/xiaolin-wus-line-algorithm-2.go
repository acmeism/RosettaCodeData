package main

// Files required to build supporting package raster are found in:
// * This task (immediately above)
// * Bitmap
// * Grayscale image
// * Write a PPM file

import "raster"

func main() {
    g := raster.NewGrmap(400, 300)
    g.AaLine(7.4, 12.3, 307, 122.5)
    g.AaLine(177.4, 12.3, 127, 222.5)
    g.Bitmap().WritePpmFile("wu.ppm")
}
