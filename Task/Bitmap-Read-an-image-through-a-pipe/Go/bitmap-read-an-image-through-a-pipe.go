package main

// Files required to build supporting package raster are found in:
// * Bitmap
// * Read a PPM file
// * Write a PPM file

import (
    "log"
    "os/exec"
    "raster"
)

func main() {
    c := exec.Command("convert", "Unfilledcirc.png", "-depth", "1", "ppm:-")
    pipe, err := c.StdoutPipe()
    if err != nil {
        log.Fatal(err)
    }
    if err = c.Start(); err != nil {
        log.Fatal(err)
    }
    b, err := raster.ReadPpmFrom(pipe)
    if err != nil {
        log.Fatal(err)
    }
    if err = b.WritePpmFile("Unfilledcirc.ppm"); err != nil {
        log.Fatal(err)
    }
}
