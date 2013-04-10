package main

// Files required to build supporting package raster are found in:
// * This task (immediately above)
// * Bitmap
// * Grayscale image
// * Read a PPM file
// * Write a PPM file

import (
    "raster"
    "fmt"
    "math"
)

func main() {
    // (A file with this name is output by the Go solution to the task
    // "Bitmap/Read an image through a pipe," but of course any 8-bit
    // P6 PPM file should work.)
    b, err := raster.ReadPpmFile("pipein.ppm")
    if err != nil {
        fmt.Println(err)
        return
    }
    g := b.Grmap()
    h := g.Histogram(0)
    // compute median
    lb, ub := 0, len(h)-1
    var lSum, uSum int
    for lb <= ub {
        if lSum+h[lb] < uSum+h[ub] {
            lSum += h[lb]
            lb++
        } else {
            uSum += h[ub]
            ub--
        }
    }
    // apply threshold and write output file
    g.Threshold(uint16(ub * math.MaxUint16 / len(h)))
    err = g.Bitmap().WritePpmFile("threshold.ppm")
    if err != nil {
        fmt.Println(err)
    }
}
