package main

import (
    "fmt"
    "image/jpeg"
    "os"
    "log"
    "image"
)

func loadJpeg(filename string) (image.Image, error) {
    f, err := os.Open(filename)
    if err != nil {
        return nil, err
    }
    defer f.Close()

    img, err := jpeg.Decode(f)
    if err != nil {
        return nil, err
    }

    return img, nil
}

func diff(a, b uint32) int64 {
    if a > b {
        return int64(a - b)
    }
    return int64(b - a)
}

func main() {
    i50, err := loadJpeg("Lenna50.jpg")
    if err != nil {
        log.Fatal(err)
    }

    i100, err := loadJpeg("Lenna100.jpg")
    if err != nil {
        log.Fatal(err)
    }

    if i50.ColorModel() != i100.ColorModel() {
        log.Fatal("different color models")
    }

    b := i50.Bounds()
    if !b.Eq(i100.Bounds()) {
        log.Fatal("different image sizes")
    }

    var sum int64
    for y := b.Min.Y; y < b.Max.Y; y++ {
        for x := b.Min.X; x < b.Max.X; x++ {
            r1, g1, b1, _ := i50.At(x, y).RGBA()
            r2, g2, b2, _ := i100.At(x, y).RGBA()
            sum += diff(r1, r2)
            sum += diff(g1, g2)
            sum += diff(b1, b2)
        }
    }

    nPixels := (b.Max.X - b.Min.X) * (b.Max.Y - b.Min.Y)
    fmt.Printf("Image difference: %f%%\n",
        float64(sum*100)/(float64(nPixels)*0xffff*3))
}
