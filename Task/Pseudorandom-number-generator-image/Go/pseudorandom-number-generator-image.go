package main

import (
    "image"
    "image/color"
    "image/png"
    "log"
    "math/rand"
    "os"
    "time"
)

func main() {
    rand.Seed(time.Now().UnixNano())
    img := image.NewNRGBA(image.Rect(0, 0, 1000, 1000))
    for x := 0; x < 1000; x++ {
        for y := 0; y < 1000; y++ {
            col := color.RGBA{uint8(rand.Intn(256)), uint8(rand.Intn(256)), uint8(rand.Intn(256)), 255}
            img.Set(x, y, col)
        }
    }
    fileName := "pseudorandom_number_generator.png"
    imgFile, err := os.Create(fileName)
    if err != nil {
        log.Fatal(err)
    }
    defer imgFile.Close()

    if err := png.Encode(imgFile, img); err != nil {
        imgFile.Close()
        log.Fatal(err)
    }
}
