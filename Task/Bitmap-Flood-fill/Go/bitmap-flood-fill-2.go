package main

import (
    "log"
    "os/exec"
    "raster"
)

func main() {
    b, err := raster.ReadPpmFile("Unfilledcirc.ppm")
    if err != nil {
        log.Fatal(err)
    }
    b.Flood(200, 200, raster.Pixel{127, 0, 0})
    c := exec.Command("convert", "ppm:-", "flood.png")
    pipe, err := c.StdinPipe()
    if err != nil {
        log.Fatal(err)
    }
    if err = c.Start(); err != nil {
        log.Fatal(err)
    }
    if err = b.WritePpmTo(pipe); err != nil {
        log.Fatal(err)
    }
    if err = pipe.Close(); err != nil {
        log.Fatal(err)
    }
}
