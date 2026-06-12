package main

import (
    "fmt"
    "image"
    "image/color"
    "image/draw"
    "math/rand"
    "time"
)

func main() {
    rect := image.Rect(0, 0, 640, 480)
    img := image.NewRGBA(rect)

    // Use blue background, say.
    blue := color.RGBA{0, 0, 255, 255}
    draw.Draw(img, rect, &image.Uniform{blue}, image.ZP, draw.Src)

    // Set color of a random pixel to yellow
    yellow := color.RGBA{255, 255, 0, 255}
    width := img.Bounds().Dx()
    height := img.Bounds().Dy()
    rand.Seed(time.Now().UnixNano())
    x := rand.Intn(width)
    y := rand.Intn(height)
    img.Set(x, y, yellow)

    // Check there's exactly one random yellow pixel.
    cmap := map[color.Color]string{blue: "blue", yellow: "yellow"}
    for i := 0; i < width; i++ {
        for j := 0; j < height; j++ {
            c := img.At(i, j)
            if cmap[c] == "yellow" {
                fmt.Printf("The color of the pixel at (%d, %d) is yellow\n", i, j)
            }
        }
    }
}
