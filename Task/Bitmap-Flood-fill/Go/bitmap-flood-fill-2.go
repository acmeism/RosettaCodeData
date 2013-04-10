package main

import (
    "fmt"
    "raster"
)

func main() {
    b, err := raster.ReadPpmFile("Unfilledcirc.ppm")
    if err != nil {
        fmt.Println(err)
        return
    }
    b.Flood(200, 200, raster.Pixel{127, 0, 0})
    err = b.WritePpmFile("flood.ppm")
    if err != nil {
        fmt.Println(err)
        return
    }
}
