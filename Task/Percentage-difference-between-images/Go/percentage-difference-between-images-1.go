package main

import (
    "fmt"
    "image/jpeg"
    "os"
)

func main() {
    f, err := os.Open("Lenna50.jpg")
    if err != nil {
        fmt.Println(err)
        return
    }
    defer f.Close()
    i50, err := jpeg.Decode(f)
    if err != nil {
        fmt.Println(err)
        return
    }
    if f, err = os.Open("Lenna100.jpg"); err != nil {
        fmt.Println(err)
        return
    }
    defer f.Close()
    i100, err := jpeg.Decode(f)
    if err != nil {
        fmt.Println(err)
        return
    }
    if i50.ColorModel() != i100.ColorModel() {
        fmt.Println("different color models")
        return
    }
    b := i50.Bounds()
    if !b.Eq(i100.Bounds()) {
        fmt.Println("different image sizes")
        return
    }
    var sum int64
    for y := b.Min.Y; y < b.Max.Y; y++ {
        for x := b.Min.X; x < b.Max.X; x++ {
            r1, g1, b1, _ := i50.At(x, y).RGBA()
            r2, g2, b2, _ := i100.At(x, y).RGBA()
            if r1 > r2 {
                sum += int64(r1 - r2)
            } else {
                sum += int64(r2 - r1)
            }
            if g1 > g2 {
                sum += int64(g1 - g2)
            } else {
                sum += int64(g2 - g1)
            }
            if b1 > b2 {
                sum += int64(b1 - b2)
            } else {
                sum += int64(b2 - b1)
            }
        }
    }
    nPixels := (b.Max.X - b.Min.X) * (b.Max.Y - b.Min.Y)
    fmt.Printf("Image difference: %f%%\n",
        float64(sum*100)/(float64(nPixels)*0xffff*3))
}
