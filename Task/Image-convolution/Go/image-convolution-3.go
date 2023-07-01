package main

// Files required to build supporting package raster are found in:
// * This task (immediately above)
// * Bitmap
// * Grayscale image
// * Read a PPM file
// * Write a PPM file

import (
    "fmt"
    "raster"
)

var blur = []float64{
    1./9, 1./9, 1./9,
    1./9, 1./9, 1./9,
    1./9, 1./9, 1./9}

var sharpen = []float64{
    -1, -1, -1,
    -1,  9, -1,
    -1, -1, -1}

func main() {
    // Example file used here is Lenna100.jpg from the task "Percentage
    // difference between images" converted with with the command
    // convert Lenna100.jpg -colorspace gray Lenna100.ppm
    b, err := raster.ReadPpmFile("Lenna100.ppm")
    if err != nil {
        fmt.Println(err)
        return
    }
    g0 := b.Grmap()
    g1 := g0.KernelFilter3(blur)
    err = g1.Bitmap().WritePpmFile("blur.ppm")
    if err != nil {
        fmt.Println(err)
    }
}
