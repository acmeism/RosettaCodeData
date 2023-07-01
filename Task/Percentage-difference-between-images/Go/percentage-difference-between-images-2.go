package main

// Files required to build supporting package raster are found in:
// * Bitmap
// * Read a PPM file

import (
    "fmt"
    "io"
    "os/exec"
    "raster"
)

func readJpeg(j string) (b *raster.Bitmap, err error) {
    c := exec.Command("convert", j, "ppm:-")
    var pipe io.Reader
    pipe, err = c.StdoutPipe()
    if err != nil {
        return
    }
    err = c.Start()
    if err != nil {
        return
    }
    return raster.ReadPpmFrom(pipe)
}

func main() {
    b1, err := readJpeg("Lenna50.jpg")
    if err != nil {
        fmt.Println(err)
        return
    }
    b2, err := readJpeg("Lenna100.jpg")
    if err != nil {
        fmt.Println(err)
        return
    }
    b1c, b1r := b1.Extent()
    b2c, b2r := b2.Extent()
    if b1c != b2c || b1r != b2r {
        fmt.Println("image extents not the same")
        return
    }
    var sum int64
    for y := 0; y < b1r; y++ {
        for x := 0; x < b1c; x++ {
            p1, _ := b1.GetPx(x, y)
            p2, _ := b2.GetPx(x, y)
            d := int64(p1.R) - int64(p2.R)
            if d < 0 {
                sum -= d
            } else {
                sum += d
            }
            d = int64(p1.G) - int64(p2.G)
            if d < 0 {
                sum -= d
            } else {
                sum += d
            }
            d = int64(p1.B) - int64(p2.B)
            if d < 0 {
                sum -= d
            } else {
                sum += d
            }
        }
    }
    fmt.Printf("Image difference: %f%%\n",
        float64(sum)*100/(float64(b1c*b1r)*255*3))
}
