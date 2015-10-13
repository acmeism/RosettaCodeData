package main

// Files required to build supporting package raster are found in:
// * Bitmap
// * Write a PPM file

import (
    "fmt"
    "math/rand"
    "os/exec"
    "raster"
)

func main() {
    b := raster.NewBitmap(400, 300)
    // a little extravagant, this draws a design of dots and lines
    b.FillRgb(0xc08040)
    for i := 0; i < 2000; i++ {
        b.SetPxRgb(rand.Intn(400), rand.Intn(300), 0x804020)
    }
    for x := 0; x < 400; x++ {
        for y := 240; y < 245; y++ {
            b.SetPxRgb(x, y, 0x804020)
        }
        for y := 260; y < 265; y++ {
            b.SetPxRgb(x, y, 0x804020)
        }
    }
    for y := 0; y < 300; y++ {
        for x := 80; x < 85; x++ {
            b.SetPxRgb(x, y, 0x804020)
        }
        for x := 95; x < 100; x++ {
            b.SetPxRgb(x, y, 0x804020)
        }
    }

    // pipe logic
    c := exec.Command("cjpeg", "-outfile", "pipeout.jpg")
    pipe, err := c.StdinPipe()
    if err != nil {
        fmt.Println(err)
        return
    }
    err = c.Start()
    if err != nil {
        fmt.Println(err)
        return
    }
    err = b.WritePpmTo(pipe)
    if err != nil {
        fmt.Println(err)
        return
    }
    err = pipe.Close()
    if err != nil {
        fmt.Println(err)
    }
}
